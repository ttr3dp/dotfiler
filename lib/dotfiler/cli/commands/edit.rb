module Dotfiler
  module CLI
    module Commands
      class Edit < Command
        include Dotfiler::Import["fs", "dotfiles"]

        desc "Edit specified dotfile. By default, dotfile will be opened in $EDITOR"

        argument :name, required: true, desc: "Name of the dotfile you want to edit"
        option :with, aliases: ["w"], required: false, desc: "Editor in which to open the specified dotfile"

        def call(name:, **options)
          handle_errors do
            validate_name!(name)

            dotfile_path = dotfiles.find(name).path.to_s
            editor       = options.fetch(:with, default_editor)

            error!("Editor is not specified. Either set the '$EDITOR' environment variable or provide '--with' option") unless editor

            fs.execute(editor, dotfile_path)
          end
        end

        private

        def validate_name!(name)
          error!("Dotfile '#{name}' not found") unless dotfiles.exists?(name)
        end

        def default_editor
          ENV["EDITOR"]
        end
      end
    end
  end
end
