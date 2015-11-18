require 'mini_portile'
require_relative 'base'

class PythonRecipe < BaseRecipe
  def computed_options
    [
      "--enable-shared",
      "--with-ensurepip=no",
      "--prefix=#{prefix_path}"
    ]
  end

  def archive_files
    [ "#{prefix_path}/*" ]
  end

  def setup_tar
    unless File.exist?("#{prefix_path}/bin/python")
      File.symlink("./python3", "#{prefix_path}/bin/python")
    end
  end

  def configure
    return if configured?

    md5_file = File.join(tmp_path, 'configure.md5')
    digest   = Digest::MD5.hexdigest(computed_options.to_s)
    File.open(md5_file, "w") { |f| f.write digest }

    execute('configure', ['bash','-c',"sed -i -e '2993s/-E/-B -R/' configure"])
    execute('configure', %w(sh configure) + computed_options)
  end

  faketime :install
  faketime :compile
  faketime :configure

  def url
    "https://www.python.org/ftp/python/#{version}/Python-#{version}.tgz"
  end

  def prefix_path
    '/app/.heroku/vendor'
  end
end
