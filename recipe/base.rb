require 'mini_portile'
require 'tmpdir'
require 'fileutils'
require_relative 'determine_checksum'
require_relative '../lib/yaml_presenter'

class BaseRecipe < MiniPortile
  def initialize(name, version, options = {})
    super name, version

    options.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    @files = [{
      url: self.url,
    }.merge(DetermineChecksum.new(options).to_h)]
  end

  def configure_options
    []
  end

  def compile
    execute('compile', [make_cmd, '-j4'])
  end

  def archive_filename
    "#{name}-#{version}-linux-x64.tgz"
  end

  def archive_files
    []
  end

  def archive_path_name
    ""
  end

  private

  # NOTE: https://www.virtualbox.org/ticket/10085
  def tmp_path
    "/tmp/#{@host}/ports/#{@name}/#{@version}"
  end

  def self.faketime(method_name)
    alias_method "#{method_name}_faketime", method_name
    define_method(method_name) do
      ENV['FAKETIME']   = '2014-01-01 00:00:00'
      ENV['LD_PRELOAD'] = '/usr/lib/x86_64-linux-gnu/faketime/libfaketime.so.1'
      send("#{method_name}_faketime")
      ENV['FAKETIME']   = nil
      ENV['LD_PRELOAD'] = nil
    end
  end
end

