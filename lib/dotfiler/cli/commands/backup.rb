module Dotfiler
  module CLI
    module Commands
      class Backup < Hanami::CLI::Command
        BACKUP_DIR       = ".dotfiler_backup".freeze
        TIMESTAMP_FORMAT = "%Y_%m_%d_%H_%M_%S".freeze

        include Dotfiler::Import["config", "copier", "remover", fs: "file_system"]

        desc "Backup existing dotfiles dir"

        def call
          copier.call(config[:dotfiles], backup_dir_path)
          remover.call(fs.to_pathname(backup_dir_path).join(".git").to_s, only_symlinks: false)
        end

        private

        def backup_dir_path
          fs.to_pathname(config.home).join("#{BACKUP_DIR}_#{current_timestamp}").to_s
        end

        def current_timestamp
          Time.now.strftime(TIMESTAMP_FORMAT)
        end
      end
    end
  end
end
