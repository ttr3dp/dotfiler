module Dotfiler
  module CLI
    module Commands
      class Unlink < Command
        include Dotfiler::Import["dotfiles", "mover", "remover"]

        desc "Remove specified dotfile from dotfiles and restore it to it's original location"

        argument :name, required: true, desc: "Name of the dotfile that should be unlinked"

        def call(name:)
          handle_errors do
            validate_name!(name)

            dotfile = dotfiles.find(name)

            info("Removing symlink (#{dotfile.link})...")
            remover.call(dotfile.link)

            info("Restoring dotfile (#{dotfile.path}) to its original location (#{dotfile.link})...")
            mover.call(dotfile.path, dotfile.link)


            info("Removing '#{name}' from dotfiles...")
            dotfiles.remove!(name)
          end
        end

        private

        def validate_name!(name)
          return if dotfiles.exists?(name)

          shell.terminate(:error, message: "Dotfile with the name '#{name}' does not exist")
        end
      end
    end
  end
end
