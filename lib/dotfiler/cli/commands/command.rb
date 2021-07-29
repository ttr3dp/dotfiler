module Dotfiler
  module CLI
    module Commands
      class Command < Hanami::CLI::Command
        include Dotfiler::Import["config", "to_path", "shell"]

        private

        def handle_errors(&block)
          begin
            yield
          rescue Dotfiler::Error => e
            error!(e.message)
          end
        end

        def print(*args)
          shell.print(*args)
        end

        def info(message)
          print(message, :info)
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
