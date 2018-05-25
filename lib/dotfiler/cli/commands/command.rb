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
              error!(exception.message)
            when SystemCallError
              raise unless exception.class.name.start_with?("Errno::")

              error!(exception.message)
            else
              raise
            end
          end
        end

        def info(message)
          shell.print(message, :info)
        end

        def error!(message)
          terminate!(:error, message: message)
        end

        def terminate!(*args)
          shell.terminate(*args)
        end

        def prompt(*args)
          shell.prompt(*args)
        end
      end
    end
  end
end
