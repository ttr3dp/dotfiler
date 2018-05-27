require "dry-container"
require "dry-auto_inject"

module Dotfiler
  class Container
    extend Dry::Container::Mixin

    register "to_path", memoize: true do
      Dotfiler::Path.method(:new)
    end

    register "fs", memoize: true do
      Dotfiler::FileSystem.new
    end

    register "config", memoize: false do
      Dotfiler::Config.new
    end

    register "links", memoize: false do
      Dotfiler::Links.new
    end

    register "copier", memoize: true do
      Dotfiler::Copier.new
    end

    register "mover", memoize: true do
      Dotfiler::Mover.new
    end

    register "symlinker", memoize: true do
      Dotfiler::Symlinker.new
    end

    register "remover", memoize: true do
      Dotfiler::Remover.new
    end

    register "shell", memoize: true do
      Dotfiler::Shell.new
    end
  end

  Import = Dry::AutoInject(Container)
end

require "dotfiler/path"
require "dotfiler/file_system"
require "dotfiler/config"
require "dotfiler/links"

require "dotfiler/copier"
require "dotfiler/mover"
require "dotfiler/symlinker"
require "dotfiler/remover"

require "dotfiler/shell"
