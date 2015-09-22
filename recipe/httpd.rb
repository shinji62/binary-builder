require 'mini_portile'
require_relative './httpd.apr'
require_relative './httpd.iconv'


class HttpdRecipe < MiniPortile
  def configure_options
    [
      '--prefix=/app/httpd' ,
    "--with-apr=#{options[:staging_dir]}/libapr-#{options[:apr_version]}" ,
    "--with-apr-util=#{options[:staging_dir]}/libapr-util-#{options[:apr_util_version]}" ,
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

  def initialize
    super
    options[:staging_dir] = "/tmp/staged/app"
    options[:apr_iconv_version] = '1.2.1'
    options[:apr_util_version] = '1.5.4'
    options[:apr_version] = '1.5.2'
  end

  def cook
    super
    HttpdAprRecipe.new('apr', options[:apr_version], options).cook
    HttpdIconvRecipe.new('iconv', options[:apr_iconv_version], options).cook
  end

  def url
    "https://archive.apache.org/dist/httpd//httpd-#{version}.tar.bz2"
  end

  def configure
    execute('configure', %w(python configure) + computed_options)
  end
end

