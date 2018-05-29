module Dotfiler
  module CLI
    module Commands
      class Link < Command
        include Dotfiler::Import["dotfiles", "symlinker", "mover"]

        desc "Add specified file/directory to dotfiles"

        argument :name,   required: true,  desc: "Name under which the dotfile will be created"
        argument :path,   required: true,  desc: "File/directory path"
        option   :target, required: false, desc: "Path to where the symlink will be created", aliases: ["-t"]

        def call(name:, path:, **options)
          handle_errors do
            validate_name!(name)

            path          = to_path.(path)
            dotfiles_path = to_path.(config[:dotfiles])
            dotfile_path  = resolve_dotfile_path(path, dotfiles_path, options)
            target_path   = to_path.(options.fetch(:target, path.to_s))

            info("Symlinking dotfile (#{dotfile_path}) to #{target_path}...")
            symlink_path  = symlinker.call(dotfile_path, target_path)

            info("Adding #{name} to dotfiles...")
            dotfiles.add!(name: name, link: symlink_path.to_s, path: dotfile_path.to_s)
          end
        end

        private

        def validate_name!(name)
          return unless dotfiles.name_taken?(name)

          error!("Dotfile with the name '#{name}' already exists")
        end

        def resolve_dotfile_path(path, dotfiles_path, options)
          if dotfiles_path.contains?(path)
            error!(already_dotfile_error(path, dotfiles_path)) if options[:target].nil?

            path
          else
            safely_move(path, dotfiles_path)
          end
        end

        def already_dotfile_error(path, dotfiles_path)
          "Specified #{path.file? ? "file" : "directory"} (#{path}) " +
            "is already in dotfiles directory (#{dotfiles_path})." +
            "\nIf you want to symlink it, please provide `--target` option"
        end

        def safely_move(source, destination)
          full_destination_path = destination.join(source.name)

          if full_destination_path.exists?
            available_options = {
              "1" => { value: :overwrite,            desc: "Overwrite it" },
              "2" => { value: :backup_and_overwrite, desc: "Backup and overwrite it" },
              "3" => { value: :cancel,               desc: "Cancel"}
            }
            answer = prompt(
              "Dotfile (#{full_destination_path}) already exists.\nWould you like to:",
              available_options
            )

            case answer
            when :overwrite
              # fall-through
            when :backup_and_overwrite
              backup(full_destination_path)
            else
              terminate!(:clean, message: "Cancelling...")
            end
          end

          move(source, destination)
        end

        def backup(path)
          info("Backing up #{path} to #{path}_old")
          mover.call(path, to_path.(path.to_s + "_old"))
        end

        def move(source, destination)
          info("Moving #{source} to dotfiles directory (#{destination})...")
          mover.call(source, destination)
        end
      end
    end
  end
end
