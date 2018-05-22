module Dotfiler
  module CLI
    module Commands
      class Command < Hanami::CLI::Command
        include Dotfiler::Import["config", "to_path", "shell"]

        private

        def handle_errors(&block)
          begin
            yield
          rescue => exception
            case exception
            when Dotfiler::Error
              shell.terminate(:error, message: exception.message)
            when SystemCallError
              raise unless exception.class.name.start_with?("Errno::")

              shell.terminate(:error, message: exception.message)
            else
              raise
            end
          end
        end
      end
    end
  end
end
