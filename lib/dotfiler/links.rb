require "forwardable"

module Dotfiler
  class Links
    extend Forwardable
    include Dotfiler::Import[fs: "file_system", config: "config", to_path: "to_path"]

    HOME_PLACEHOLDER     = "%home%".freeze
    DOTFILES_PLACEHOLDER = "%dotfiles%".freeze

    def_delegators :config, :home_path, :relative_home_path

    def initialize(args)
      super(args)
      load_data!
    end

    def [](tag)
      @data[tag]
    end

    def each(&block)
      @data.each do |tag, details|
        yield(tag, details)
      end
    end

    def tags
      @data.keys
    end

    def tag_taken?(tag)
      tags.include?(tag)
    end

    def append!(tag, info)
      File.open(config.links_file_path.to_s, "a") do |file|
        file << link_to_line(tag, info)
      end

      reload!
    end

    def remove!(tag)
      content = @data.each_with_object("") do |(_tag, info), result|
        next if _tag == tag

        result << link_to_line(_tag, info)
      end

      File.open(config.links_file_path.to_s, "w+") { |file| file << content }

      reload!
    end

    def list
      @data.each_with_object([]) do |(tag, info), result|
        result << { tag: tag }.merge(info)
      end
    end

    def load_data!
      @data = if config.set?
                parse(File.readlines(config.links_file_path.to_s))
              else
                {}
              end
    end

    alias_method :reload!, :load_data!

    private

    def parse(lines)
      lines.each_with_object({}) do |line, result|
        sanitized_line = line.gsub("\n", "")

        next if sanitized_line.empty?

        tag, link, path = sanitized_line.split(" :: ")

        link = link.sub(HOME_PLACEHOLDER, home_path.to_s)
        path = path.sub(DOTFILES_PLACEHOLDER, config[:dotfiles])

        result[tag] = { link: link, path: path }
      end
    end

    def link_to_line(tag, info)
      link, path = info.values_at(:link, :path)

      link       = link.sub(home_path.to_s, HOME_PLACEHOLDER)
      path       = path.sub(config[:dotfiles], DOTFILES_PLACEHOLDER)

      [tag, link, path].join(" :: ") + "\n"
    end
  end
end
