require "dry-container"
require "dry-auto_inject"

module Dotfiler
  class Container
    extend Dry::Container::Mixin

    register "file_system", memoize: true do
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

    register "output", memoize: true do
      Dotfiler::Output.new
    end
  end

  Import = Dry::AutoInject(Container)
end

require "dotfiler/file_system"
require "dotfiler/config"
require "dotfiler/links"

require "dotfiler/copier"
require "dotfiler/mover"
require "dotfiler/symlinker"
require "dotfiler/remover"

require "dotfiler/output"
