module Dotfiler
  module CLI
    module Commands
      class Unlink < Command
        include Dotfiler::Import["links", "mover", "remover", "shell"]

        desc "Unlink specified dotfile and restore it to original location"

        argument :tag, required: true, desc: "dotfile tag"

        def call(tag:)
          validate_tag!(tag)

          symlink, dotfile = links[tag].values_at(:link, :path)

          remover.call(symlink)
          mover.call(dotfile, symlink)
          links.remove!(tag)
        end

        private

        def validate_tag!(tag)
          return if tag_exists?(tag)

          shell.print("'#{tag}' tag doesn't exist", :error)
          exit(1)
        end

        def tag_exists?(tag)
          links.tags.include?(tag)
        end
      end
    end
  end
end
