module Dotfiler
  class Copier
    include Dotfiler::Import[fs: "file_system"]

    def call(source, target)
      check_paths!(source, fs.to_pathname(target).parent)

      fs.copy(source, target)

      source_name = fs.basename(source)

      fs.to_pathname(target).join(source_name).to_s
    end

    private

    def check_paths!(*paths)
      paths.each do |path|
        raise Error, "Path '#{path}' does not exist" unless fs.exists?(path)
      end
    end
  end
end
