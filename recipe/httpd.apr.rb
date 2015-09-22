require 'mini_portile'

class HttpdAprRecipe < MiniPortile
  def configure_options
    [
      "--prefix=#{options[:staging_dir]}/libapr-#{version}"
    ]
  end

  def url
    "http://apache.mirrors.tds.net/apr/apr-#{version}.tar.gz"
  end
end

