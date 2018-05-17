require "pathname"
require "fileutils"

module Dotfiler
  class FileSystem
    attr_reader :file_utils

    def initialize(file_utils = FileUtils)
      @file_utils = FileUtils
    end

    def file?(input)
      File.file?(expand(input))
    end

    def dir?(input)
      File.directory?(expand(input))
    end

    def symlink?(input)
      File.symlink?(expand(input))
    end

    def file_exists?(input)
      full_path = expand(input)
      File.exist?(full_path) && file?(full_path)
    end

    def dir_exists?(input)
      Dir.exists?(expand(input))
    end

    def exists?(input)
      file_exists?(input) || dir_exists?(input)
    end

    def path(input)
      expand(input)
    end

    def realpath(input)
      File.realpath(expand(input))
    end

    def basename(input)
      File.basename(input)
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

    def expand(input)
      File.expand_path(input)
    end

    def to_pathname(input)
      Pathname.new(input)
    end
  end
end
