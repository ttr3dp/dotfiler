module Dotfiler
  class Symlinker
    include Dotfiler::Import[fs: "file_system"]

    def call(source, link_path, options = {})
      check_paths!(source, link_path.parent_dir)

      fs.symlink(source.to_s, link_path.to_s, options)

      link_path
    end

    private

    def check_paths!(*paths)
      paths.each do |path|
        raise Error, "Path '#{path}' does not exist" unless path.exists?
      end
    end
  end
end
