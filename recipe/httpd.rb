require 'mini_portile'
require_relative './httpd.apr'
require_relative './httpd.iconv'
require_relative './httpd.util'


class HttpdRecipe < MiniPortile
  def configure_options
    [
      "--with-apr=#{@staging_dir}/libapr-#{@apr_version}" ,
      "--with-apr-util=#{@staging_dir}/libapr-util-#{@apr_util_version}" ,
      "--enable-mpms-shared=worker event" ,
      "--enable-mods-shared=reallyall" ,
      "--disable-isapi" ,
      "--disable-dav" ,
      "--disable-dialup"
    ]
  end

  def port_path
    "/app/httpd"
  end

  def compile
    execute('compile', [make_cmd, "prefix=/tmp/httpd"])
  end

  def initialize name, version
    super
    @apr_version = '1.5.2'
    @staging_dir = "/tmp/staged/app"
    @apr_iconv_version = '1.2.1'
    @apr_util_version = '1.5.4'
  end

  def cook
    httpd_apr_recipe = HttpdAprRecipe.new('apr', @apr_version, @staging_dir)
    httpd_apr_recipe.cook

    httpd_iconv_recipe = HttpdIconvRecipe.new('iconv', @apr_iconv_version, @staging_dir, @apr_version)
    httpd_iconv_recipe.cook

    httpd_util_recipe = HttpdUtilRecipe.new('util', @apr_util_version, @staging_dir, @apr_version, @apr_iconv_version)
    httpd_util_recipe.cook
    super
    system   <<-eof
      cd /app/httpd
      rm -rf build/ cgi-bin/ error/ icons/ include/ man/ manual/ htdocs/
      rm -rf conf/extra/* conf/httpd.conf conf/httpd.conf.bak conf/magic conf/original
      # Install required libraries
  mkdir /app/httpd/lib
  cp "#{@staging_dir}/libapr-#{@apr_version}/lib/libapr-1.so.0" /app/httpd/lib
  cp "#{@staging_dir}/libapr-util-#{@apr_util_version}/lib/libaprutil-1.so.0" /app/httpd/lib
  cp "#{@staging_dir}/libapr-iconv-#{@apr_iconv_version}/lib/libapriconv-1.so.0" /app/httpd/lib
      ls -A /app/httpd | xargs tar czf httpd-#{version}-linux-x64.tgz -C /app/httpd
    eof
  end

  def url
    "https://archive.apache.org/dist/httpd/httpd-#{version}.tar.bz2"
  end

end

