module Dotfiler
  module CLI
    module Commands
      class Init < Command
        include Dotfiler::Import[config: "config", shell: "shell", fs: "file_system"]

        desc "Create initial configuration. Create dotfiles dir at specified path. Initialize git repo."

        argument :path, required: true, desc: "Dotfiles directory path"
        option :git, type: :boolean, default: true, desc: "Initialize git repo for dotfiles directory"

        def call(path:, **options)
          dotfiles_path = fs.path(path)

          begin
            create_config_file(config_file_contents(dotfiles_path))
            create_dotfiles_dir(dotfiles_path)
            create_links_file(dotfiles_path)

            initialize_vcs_repo(dotfiles_path) unless options[:git] == false
          rescue => e
            shell.print(e.message, :error)
            exit(1)
          end
        end

        private

        def config_file_contents(dotfiles_path)
          "dotfiles: #{dotfiles_path}"
        end

        def create_config_file(contents)
          file_path = config.file.to_s

          if fs.file_exists?(file_path)
            answer = shell.prompt("Config file (#{file_path}) already exists. Would you like to overwrite it?")

            return unless answer == :yes
          end

          info("Creating config file (#{file_path})...")
          fs.create_file(file_path, contents)
        end

        def create_dotfiles_dir(dotfiles_path)
          if fs.dir_exists?(dotfiles_path)
            answer = shell.prompt("Dotfiles directory (#{dotfiles_path}) already exists. Would you like to overwrite it?")

            return unless answer == :yes

            info("Removing existing dotfiles directory (#{dotfiles_path})...")
            fs.remove(dotfiles_path)
          end

          info("Creating dotfiles directory (#{dotfiles_path})...")
          fs.create_dir(dotfiles_path)
        end

        def create_links_file(dotfiles_path)
          file_name = config.class::LINKS_FILE
          path      = fs.to_pathname(dotfiles_path).join(file_name).to_s

          if fs.file_exists?(path)
            answer = shell.prompt("Links file (#{path}) already exists. Would you like to overwrite it?")

            return unless answer == :yes
          end

          info("Creating links file (#{path})...")
          fs.create_file(path)
        end

        def initialize_vcs_repo(dotfiles_path)
          if fs.dir_exists?(dotfiles_path + "/.git")
            answer = shell.prompt("Dotfiles dir (#{dotfiles_path}) is already a git repository. Would you like to reinitialize it?")

            return unless answer == :yes
          end

          info(fs.execute("git", "init", dotfiles_path, capture: true))
        end

        def info(message)
          shell.print(message, :info)
        end
      end
    end
  end
end
