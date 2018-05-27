module Dotfiler
  module CLI
    module Commands
      class Edit < Command
        include Dotfiler::Import["fs", "links"]

        desc "Edit specified dotfile with $EDITOR"

        option :with, aliases: ["w"], required: false, desc: "Editor in which to open the specified dotfile"

        def call(tag:, **options)
          handle_errors do
            validate_tag!(tag)

            dotfile_path = links[tag].fetch(:path)
            editor       = options.fetch(:with, default_editor)

            error!("Editor is not specified. Either set the '$EDITOR' environment variable or provide '--with' option") unless editor

            fs.execute(editor, dotfile_path)
          end
        end

        private

        def validate_tag!(tag)
          error!("Tag '#{tag}' not found") unless links.tag_exists?(tag)
        end

        def default_editor
          ENV["EDITOR"]
        end
      end
    end
  end
end
