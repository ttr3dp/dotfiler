module Dotfiler
  module CLI
    module Commands
      class Edit < Command
        include Dotfiler::Import["fs", "links"]

        argument :tag, required: true,  desc: "Dotfile tag"

        def call(tag:)
          handle_errors do
            validate_tag!(tag)

            dotfile_path = links[tag].fetch(:path)

            error!("Editor is not configured. Please set $EDITOR environment variable on your system") unless editor

            fs.execute(editor, dotfile_path)
          end
        end

        private

        def validate_tag!(tag)
          error!("Tag '#{tag}' not found") unless links.tag_exists?(tag)
        end

        def editor
          ENV["EDITOR"]
        end
      end
    end
  end
end
