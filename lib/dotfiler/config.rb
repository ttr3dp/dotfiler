require "yaml"

module Dotfiler
  class Config
    CONFIG_FILE = ".dotfiler".freeze
    LINKS_FILE  = ".links".freeze

    include Dotfiler::Import[fs: "file_system"]

    def initialize(*args)
      super
      @data = load_data
    end

    def [](key)
      @data[key]
    end

    def file
      fs.path("#{home}/#{CONFIG_FILE}")
    end

    def home(relative: false)
      relative ? "~" : Dir.home
    end

    def links
      fs.path("#{self[:dotfiles]}/#{LINKS_FILE}")
    end

    private

    def load_data
      if fs.file_exists?(file)
        YAML.load_file(file).each_with_object({}) do |(k, v), result|
          result[k.to_sym] = v
        end
      else
        {}
      end
    end
  end
end
