require "pathname"

module Dotfiler
  class Path
    def initialize(raw_path, expand: true)
      @path = raw_path.nil? ? "" : raw_path
      @full_path = Pathname.new(raw_path)
      @full_path = @full_path.expand_path if expand == true
    end

    def full
      @full_path
    end

    def to_s
      @full_path.to_s
    end

    def join(*paths)
      new_path = @full_path

      paths.each { |path| new_path = new_path.join(path) }

      self.class.new(new_path.to_s)
    end

    def parent_dir
      self.class.new(@full_path.parent.to_s)
    end

    def real
      @full_path.realpath
    end

    def name
      @full_path.basename
    end

    def exists?
      File.exists?(self.to_s)
    end

    def file?
      !dir? && File.file?(@full_path)
    end

    def dir?
      File.directory?(@full_path)
    end

    def symlink?
      File.symlink?(@full_path)
    end
  end
end
