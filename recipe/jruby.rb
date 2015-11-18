require 'mini_portile'
require_relative 'base'

class JRubyRecipe < BaseRecipe
  def archive_files
    [
      "#{work_path}/bin",
      "#{work_path}/lib"
    ]
  end


  def url
    "https://s3.amazonaws.com/jruby.org/downloads/#{jruby_version}/jruby-src-#{jruby_version}.tar.gz"
  end

  def cook
    download unless downloaded?
    extract
    compile
    install
  end

  def compile
    execute('compile', ['mvn', "dependency:resolve"])
    execute('compile', ['mvn', "dependency:resolve-plugins"])
  end

  def install
    execute('install', [
      "env",
      'JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64/',
      "ANT_HOME=/binary-builder/ports/x86_64-linux-gnu/ant/1.9.6/bin/",
      "mvn", "-Djruby.default.ruby.version=#{ruby_version}", "-o"
    ])
  end
  faketime :install

  def ruby_version
    @ruby_version ||= version.match(/.*_ruby-(\d+\.\d).*/)[1]
  end

  def jruby_version
    @jruby_version ||= version.match(/(.*)_ruby-\d+\.\d.*/)[1]
  end
end

