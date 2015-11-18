require 'tmpdir'
require_relative 'yaml_presenter'

class ArchiveRecipe
  def initialize(recipe)
    @recipe = recipe
  end

  def tar!
    return if @recipe.archive_files.empty?

    # when tar reads the file it modifies the access date of the file
    # we keep it consistent for any tar built
    ENV['FAKETIME']   = '2014-01-01 00:00:00'
    ENV['LD_PRELOAD'] = '/usr/lib/x86_64-linux-gnu/faketime/libfaketime.so.1'
    @recipe.setup_tar if @recipe.respond_to? :setup_tar

    Dir.mktmpdir do |dir|
      archive_path = File.join(dir, @recipe.archive_path_name)
      FileUtils.mkdir_p(archive_path)

      @recipe.archive_files.each do |glob|
        `cp -r #{glob} #{archive_path}`
      end

      File.write("#{dir}/sources.yml", YAMLPresenter.new(@recipe).to_yaml)

      print "Running 'archive' for #{@recipe.name} #{@recipe.version}... "
      `ls -A #{dir} | xargs tar czf #{@recipe.archive_filename} -C #{dir}`
      puts "OK"
    end
    ENV['FAKETIME']   = nil
    ENV['LD_PRELOAD'] = nil
  end
end
