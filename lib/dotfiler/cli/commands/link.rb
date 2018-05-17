module Dotfiler
  module CLI
    module Commands
      class Link < Command
        include Dotfiler::Import["config", "links", "symlinker", "mover", "output"]

        desc "Add specified file/dir to dotfiles"

        argument :tag, required: true, desc: "dotfile tag"
        argument :path, required: true, desc: "dotfile path"

        def call(tag:, path:)
          validate_tag!(tag)

          dotfile_path = mover.call(path, config[:dotfiles])
          symlink      = symlinker.call(dotfile_path, path)

          links.append!(tag, link: symlink, path: dotfile_path)
        end

        private

        def validate_tag!(tag)
          return unless tag_exists?(tag)

          output.error("'#{tag}' tag already exists")
          exit(1)
        end

        def tag_exists?(tag)
          links.tags.include?(tag)
        end
      end
    end
  end
end
