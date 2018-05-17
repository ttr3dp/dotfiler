module Dotfiler
  class Symlinker
    include Dotfiler::Import[fs: "file_system"]

    def call(source, link_path)
      check_paths!(source, fs.to_pathname(link_path).parent)

      fs.symlink(source, link_path)

      link_path
    end

    private

    def check_paths!(*paths)
      paths.each do |path|
        raise Error, "Path '#{path}' does not exist" unless fs.exists?(path)
      end
    end
  end
end
