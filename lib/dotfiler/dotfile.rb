module Dotfiler
  class Dotfile
    attr_reader :name, :link, :path

    def initialize(name:, link:, path:)
      @name = name

      to_path = Dotfiler.resolve["to_path"]

      @link = to_path.(link)
      @path = to_path.(path)
    end

    def to_h
      { name: name, link: link.to_s, path: path.to_s }
    end
  end
end
