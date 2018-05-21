module Dotfiler
  class Mover
    include Dotfiler::Import[fs: "file_system"]

    def call(source, target)
      check_paths!(source, target.parent_dir)

      fs.move(source.to_s, target.to_s, force: false, secure: true)

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
