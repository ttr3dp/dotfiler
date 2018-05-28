module Dotfiler
  module CLI
    module Commands
      class List < Command
        include Dotfiler::Import["dotfiles"]

        desc "List all managed dotfiles"

        argument :names, desc: "List only names of managed dotfiles"

        def call(names: nil)
          handle_errors do
            if dotfiles.list.empty?
              terminate!(:info, message: "No dotfiles are managed at the moment")
            else
              content = generate_list(names_only: !names.nil?)
              shell.print(content)
            end
          end
        end

        private

        def generate_list(names_only: false)
          content = ""

          dotfiles.each do |dotfile|
            name, link, path = dotfile.to_h.values_at(:name, :link, :path)

            content += "  #{name}\n"

            if !names_only
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
