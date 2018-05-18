module Dotfiler
  module CLI
    module Commands
      class Version < Command
        include Dotfiler::Import["shell"]

        desc "Show version"

        def call(*)
          shell.print("dotfiler #{Dotfiler::VERSION}")
        end
      end
    end
  end
end
