module Dotfiler
  module CLI
    module Commands
      class Version < Command
        desc "Show version"

        def call(*)
          shell.print("dotfiler #{Dotfiler::VERSION}")
        end
      end
    end
  end
end
