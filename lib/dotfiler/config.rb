require "yaml"

module Dotfiler
  class Config
    CONFIG_FILE        = ".dotfiler".freeze
    LINKS_FILE         = ".links".freeze
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

    def links_file_path
      @_links_file_path = path(self[:dotfiles]).join(links_file_name) if set?
    end

    def links_file_name
      LINKS_FILE
    end

    def reload!
      @data = load_data
    end

    def update!(args = {})
      new_data     = @data.merge(args).sort
      file_content = YAML.dump(new_data)

      fs.create_file(file_path.to_s, file_content)

      reload!
    end

    private

    def path(input, *opts)
      to_path.(input, *opts)
    end

    def load_data
      return {} unless set?

      YAML.load_file(file_path.to_s).each_with_object({}) do |(setting, value), result|
        result[setting.to_sym] = value
      end
    end
  end
end
