module Dotfiler
  module CLI
    module Commands
      class Unlink < Command
        include Dotfiler::Import["links", "mover", "remover"]

        desc "Unlink specified dotfile and restore it to original location"

        argument :tag, required: true, desc: "dotfile tag"

        def call(tag:)
          handle_errors do
            validate_tag!(tag)

            symlink_path, dotfile_path = links[tag].values_at(:link, :path).map do |item|
              to_path.(item)
            end

            info("Removing symlink (#{symlink_path})...")
            remover.call(symlink_path)

            info("Restoring dotfile (#{dotfile_path}) to its original location (#{symlink_path})...")
            mover.call(dotfile_path, symlink_path)


            info("Removing '#{tag}' from Dotfiler links...")
            links.remove!(tag)
          end
        end

        private

        def validate_tag!(tag)
          return if tag_exists?(tag)

          shell.terminate(:error, message: "'#{tag}' tag doesn't exist")
        end

        def tag_exists?(tag)
          links.tags.include?(tag)
        end
      end
    end
  end
end
