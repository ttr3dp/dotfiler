module Dotfiler
  class Dotfile
    attr_reader :name, :link, :path

    def initialize(args)
      @name = args.fetch(:name)
      @link = to_path.(args.fetch(:link))
      @path = to_path.(args.fetch(:path))
    end

    def to_h
      { name: name, link: link.to_s, path: path.to_s }
    end

    private

    def to_path
      Dotfiler.resolve["to_path"]
    end
  end
end
