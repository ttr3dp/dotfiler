module Dotfiler
  module CLI
    module Commands
      class Init < Command
        include Dotfiler::Import[fs: "file_system"]

        desc "Create initial configuration. Create dotfiles dir at specified path. Initialize git repo."

        argument :path, required: true, desc: "Dotfiles directory path"
        option :git, type: :boolean, default: true, desc: "Initialize git repo for dotfiles directory"

        def call(path:, **options)
          handle_errors do
            dotfiles_path = to_path.call(path)

            create_config_file(config_file_contents(dotfiles_path))
            create_dotfiles_dir(dotfiles_path)
            create_links_file(dotfiles_path)
            initialize_vcs_repo(dotfiles_path) unless options[:git] == false
          end
        end

        private

        def config_file_contents(dotfiles_path)
          "dotfiles: #{dotfiles_path.to_s}"
        end

        def create_config_file(contents)
          if config.file_path.exists?
            answer = prompt("Config file (#{config.file_path}) already exists. Would you like to overwrite it?")

            return unless answer == :yes
          end

          info("Creating config file (#{config.file_path})...")
          fs.create_file(config.file_path.to_s, contents)
        end

        def create_dotfiles_dir(dotfiles_path)
          if dotfiles_path.exists?
            answer = prompt("Dotfiles directory (#{dotfiles_path}) already exists. Would you like to overwrite it?")

            return unless answer == :yes

            info("Removing existing dotfiles directory (#{dotfiles_path})...")
            fs.remove(dotfiles_path.to_s)
          end

          info("Creating dotfiles directory (#{dotfiles_path})...")
          fs.create_dir(dotfiles_path.to_s)
        end

        def create_links_file(dotfiles_path)
          links_file = dotfiles_path.join(config.links_file_name)

          if links_file.exists?
            answer = prompt("Links file (#{links_file}) already exists. Would you like to overwrite it?")

            return unless answer == :yes
          end

          info("Creating links file (#{links_file})...")
          fs.create_file(links_file.to_s)
        end

        def initialize_vcs_repo(dotfiles_path)
          if dotfiles_path.join(".git").exists?
            answer = prompt("Dotfiles dir (#{dotfiles_path}) is already a git repository. Would you like to reinitialize it?")

            return unless answer == :yes
          end

          info(fs.execute("git", "init", dotfiles_path.to_s, capture: true))
        end
      end
    end
  end
end
