require 'mini_portile'
require_relative './httpd.rb'

class HttpdIconvRecipe < MiniPortile

  def configure_options
    [
      "--prefix=#{options[:staging_dir]}/libapr-iconv-#{version}",
      "--with-apr=#{options[:staging_dir]}/libapr-#{options[:apr_version]}/bin/apr-1-config"
    ]
  end

  def url
    "http://apache.mirrors.tds.net/apr/apr-iconv-#{version}.tar.gz"
  end
end

