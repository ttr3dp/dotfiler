module Dotfiler
  class Copier
    include Dotfiler::Import[fs: "file_system"]

    def call(source, target, options = {})
      check_paths!(source, target.parent_dir)

      fs.copy(source.to_s, target.to_s, options)

      target.join(source.name)
    end

    private

    def check_paths!(*paths)
      paths.each do |path|
        raise Error, "Path '#{path}' does not exist" unless path.exists?
      end
    end
  end
end
