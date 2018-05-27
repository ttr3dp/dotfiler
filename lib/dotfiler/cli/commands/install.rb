module Dotfiler
  module CLI
    module Commands
      class Install < Command
        BACKUP_DIR       = "dotfiler_installation_backup".freeze
        TIMESTAMP_FORMAT = "%Y_%m_%d_%H_%M_%S".freeze

        include Dotfiler::Import[ "fs", "links", "mover", "symlinker"]

        desc "Install dotfiles from existing dotfiles directory"

        argument :path, required: true, desc: "Path to existing dotfiles directory"

        def call(path: , **options)
          handle_errors do
            dotfiles_path = to_path.(path)

            validate_links_file!(dotfiles_path)

            configure_dotfiles_dir(dotfiles_path)

            config.reload!
            links.config.reload!
            links.reload!

            create_symlinks
          end
        end

        private

        def validate_links_file!(dotfiles_path)
          links_path = dotfiles_path.join(config.links_file_name)

          return if links_path.file?

          error!("Links file (#{links_path}) not found...")
        end

        def configure_dotfiles_dir(dotfiles_path)
          if config.set?
            config.update!(dotfiles: "dotfiles: #{dotfiles_path.to_s}")
          else
            fs.create_file(config.file_path.to_s, "dotfiles: #{dotfiles_path.to_s}")
          end
        end

        def create_symlinks
          links.each do |tag, details|
            link_path, path = details.values_at(:link, :path).map { |item| to_path.(item) }

            backup(link_path) if link_path.exists? && !link_path.symlink?

            info("Symlinking dotfile (#{path}) to #{link_path}...")
            symlinker.call(path, link_path, force: true)
          end
        end

        def backup(path)
          fs.create_dir(backup_dir_path.to_s) unless backup_dir_path.exists?
          info("Backing up #{path} to #{backup_dir_path}...")
          mover.call(path, backup_dir_path)
        end

        def backup_dir_path
          @_backup_dir_path ||= config.home_path.join("#{BACKUP_DIR}_#{current_timestamp}")
        end

        def current_timestamp
          Time.now.strftime(TIMESTAMP_FORMAT)
        end
      end
    end
  end
end
