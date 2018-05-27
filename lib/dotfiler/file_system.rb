require "fileutils"

module Dotfiler
  class FileSystem
    attr_reader :utils

    def initialize(utils: FileUtils)
      @utils = utils
    end

    def move(source_path, destination_path, *options)
      utils.move(source_path, destination_path, *options)
    end

    def copy(source_path, destination_path, *options)
      utils.cp_r(source_path, destination_path, *options)
    end

    def symlink(source, destination, *options)
      utils.symlink(source, destination, *options)
    end

    def remove(path)
      utils.remove_entry_secure(path)
    end

    def create_file(name, content = "")
      file = File.new(name, "w+")
      file.write(content)
      file.close
    end

    def create_dir(path, *options)
      utils.mkdir_p(path, *options)
    end

    def execute(command, *command_options, **options)
      full_command = ([command] + command_options).join(" ")

      options[:capture] == true ?  `#{full_command}` : system(full_command)
    end
  end
end
