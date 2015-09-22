require 'mini_portile'
require_relative './httpd.apr'
require_relative './httpd.iconv'


class HttpdRecipe < MiniPortile
  def configure_options
    [
      '--prefix=/app/httpd' ,
      "--with-apr=#{@staging_dir}/libapr-#{@apr_version}" ,
      "--with-apr-util=#{@staging_dir}/libapr-util-#{@apr_util_version}" ,
      "--enable-mpms-shared=worker event" ,
      "--enable-mods-shared=reallyall" ,
      "--disable-isapi" ,
      "--disable-dav" ,
      "--disable-dialup"
    ]
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
    Bundler.with_clean_env { httpd_apr_recipe.cook }

    httpd_iconv_recipe = HttpdIconvRecipe.new('iconv', @apr_iconv_version, @staging_dir, @apr_version)
    Bundler.with_clean_env { httpd_iconv_recipe.cook }
    super
  end

  def url
    "https://archive.apache.org/dist/httpd/httpd-#{version}.tar.bz2"
  end

end

