require "yaml"

module Dotfiler
  class Config
    CONFIG_FILE        = ".dotfiler".freeze
    DOTFILES_FILE      = ".dotfiles".freeze
    RELATIVE_HOME_PATH = "~".freeze

    include Dotfiler::Import["fs", "to_path"]

    def initialize(*args)
      super
      @data = load_data
    end

    def [](setting)
      @data[setting]
    end

    def file_path
      @_file_path ||= home_path.join(CONFIG_FILE)
    end

    def home_path
      @_home_path ||= path(ENV["DOTFILER_HOME"] || Dir.home)
    end

    def relative_home_path
      @_relative_home_path ||= path(RELATIVE_HOME_PATH, expand: false)
    end

    def set?
      file_path.exists?
    end

    def dotfiles_file_path
      path(self[:dotfiles]).join(dotfiles_file_name) if set?
    end

    def dotfiles_file_name
      DOTFILES_FILE
    end

    def reload!
      @data = load_data
    end

    def update!(args = {})
      new_data     = @data.merge(args)
      file_content = new_data.each_with_object([]) { |(k, v), result| result << "#{k}: #{v}" }.join("\n")

      fs.create_file(file_path.to_s, file_content)

      reload!
    end

    private

    def path(input, *opts)
      to_path.(input, *opts)
    end

    def load_data
      return {} unless set?

      (YAML.load_file(file_path.to_s) || {}).each_with_object({}) do |(setting, value), result|
        result[setting.to_sym] = value
      end
    end
  end
end
