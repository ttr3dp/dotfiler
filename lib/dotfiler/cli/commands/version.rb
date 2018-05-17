module Dotfiler
  module CLI
    module Commands
      class Version < Command
        include Dotfiler::Import["output"]

        desc "Show version"

        def call(*)
          output.print("dotfiler #{Dotfiler::VERSION}")
        end
      end
    end
  end
end
