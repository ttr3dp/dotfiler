module Dotfiler
  module CLI
    module Commands
      class Link < Command
        include Dotfiler::Import[
          "config",
          "links",
          "symlinker",
          "mover",
          "shell",
          "to_path"
        ]

        desc "Add specified file/dir to dotfiles"

        argument :tag,  required: true, desc: "dotfile tag"
        argument :path, required: true, desc: "dotfile path"

        def call(tag:, path:)
          validate_tag!(tag)

          path = to_path.(path)
          dotfiles_path = to_path.(config[:dotfiles])

          dotfile_path = mover.call(path, dotfiles_path)
          symlink_path = symlinker.call(dotfile_path, path)

          links.append!(tag, link: symlink_path.to_s, path: dotfile_path.to_s)
        end

        private

        def validate_tag!(tag)
          return unless tag_exists?(tag)

          shell.terminate(:error, message: "'#{tag}' tag already exists")
        end

        def tag_exists?(tag)
          links.tags.include?(tag)
        end
      end
    end
  end
end
