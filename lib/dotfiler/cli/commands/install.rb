module Dotfiler
  module CLI
    module Commands
      class Install < Command
        BACKUP_DIR       = "dotfiler_installation_backup".freeze
        TIMESTAMP_FORMAT = "%Y_%m_%d_%H_%M_%S".freeze

        include Dotfiler::Import[ "fs", "dotfiles", "mover", "symlinker"]

        desc "Install dotfiles from existing dotfiles directory"

        argument :path, required: true, desc: "Path to existing dotfiles directory"

        def call(path: , **options)
          handle_errors do
            dotfiles_path = to_path.(path)

            validate_dotfiles_file!(dotfiles_path)

            configure_dotfiles_dir(dotfiles_path)

            config.reload!
            dotfiles.config.reload!
            dotfiles.reload!

            create_symlinks
          end
        end

        private

        def validate_dotfiles_file!(dotfiles_path)
          dotfiles_path = dotfiles_path.join(config.dotfiles_file_name)

          return if dotfiles_path.file?

          error!("Dotfiles file (#{dotfiles_path}) not found...")
        end

        def configure_dotfiles_dir(dotfiles_path)
          config.update!(dotfiles: dotfiles_path.to_s)
        end

        def create_symlinks
          dotfiles.each do |dotfile|
            backup(dotfile.link) if dotfile.link.exists? && !dotfile.link.symlink?

            info("Symlinking dotfile (#{dotfile.path}) to #{dotfile.link}...")
            symlinker.call(dotfile.path, dotfile.link, force: true)
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
