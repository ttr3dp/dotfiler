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

          info("Creating config file (#{file_path})...")
          fs.create_file(config.file.to_s, contents)
        end

        def create_dotfiles_dir(dotfiles_path)
          info("Creating dotfiles directory (#{dotfiles_path})...")
          fs.create_dir(dotfiles_path)
        end

        def create_links_file(dotfiles_path)
          file_name = config.class::LINKS_FILE
          path = fs.to_pathname(dotfiles_path).join(file_name).to_s

          info("Creating links file (#{path})...")
          fs.create_file(path)
        end

        def initialize_vcs_repo(dotfiles_path)
          info(fs.execute("git", "init", dotfiles_path, capture: true))
        end

        def info(message)
          shell.print(message, :info)
        end
      end
    end
  end
end
