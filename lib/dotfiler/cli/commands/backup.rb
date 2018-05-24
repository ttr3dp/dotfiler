module Dotfiler
  module CLI
    module Commands
      class Backup < Command
        BACKUP_DIR       = ".dotfiler_backup".freeze
        TIMESTAMP_FORMAT = "%Y_%m_%d_%H_%M_%S".freeze

        include Dotfiler::Import["copier", "remover"]

        desc "Backup existing dotfiles dir"

        def call(*)
          handle_errors do
            info("Backing up dotfiles directory (#{dotfiles_path}) to #{backup_dir_path}...")
            copier.call(dotfiles_path, backup_dir_path)
            remover.call(backup_dir_path.join(".git"), only_symlinks: false)
          end
        end

        private

        def backup_dir_path
          config.home_path.join("#{BACKUP_DIR}_#{current_timestamp}")
        end

        def current_timestamp
          Time.now.strftime(TIMESTAMP_FORMAT)
        end

        def dotfiles_path
          to_path.(config[:dotfiles])
        end
      end
    end
  end
end
