require "pathname"
require "fileutils"

module Dotfiler
  class FileSystem
    attr_reader :file_utils

    def initialize(file_utils = FileUtils)
      @file_utils = FileUtils
    end

    def move(source_path, destination_path, *options)
      file_utils.move(source_path, destination_path, *options)
    end

    def copy(source_path, destination_path, *options)
      file_utils.cp_r(source_path, destination_path, *options)
    end

    def symlink(source, destination, *options)
      file_utils.symlink(source, destination, *options)
    end

    def remove(path)
      file_utils.remove_entry_secure(path)
    end

    def create_file(name, content = "")
      file = File.new(name, "w+")
      file.write(content)
      file.close
    end

    def create_dir(path, *options)
      file_utils.mkdir_p(path, *options)
    end

    def execute(command, *command_options, **options)
      full_command = ([command] + command_options).join(" ")

      options[:capture] == true ?  `#{full_command}` : system(command, *options)
    end
  end
end
