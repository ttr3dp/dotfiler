module Dotfiler
  module CLI
    module Commands
      class List < Command
        include Dotfiler::Import["links", "output"]

        desc "Lists all managed dotfiles"

        argument :tags, desc: "List tags only"

        def call(tags: nil)
          if links.list.empty?
            output.print("  No dotfiles are managed at the moment")
            exit(0)
          else
            content = generate_list(tags_only: !tags.nil?)
            output.print(content)
          end
        end

        private

        def generate_list(tags_only: false)
          content = ""

          links.list.each do |item|
            tag, link, path = item.values_at(:tag, :link, :path)

            content += "  #{tag}\n"

            if !tags_only
              content += "    - LINK: #{link}\n"
              content += "    - PATH: #{path}\n\n"
            end
          end

          content
        end
      end
    end
  end
end
