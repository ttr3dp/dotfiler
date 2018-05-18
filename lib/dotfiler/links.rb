require "forwardable"

module Dotfiler
  class Links
    extend Forwardable
    include Dotfiler::Import[fs: "file_system", config: "config"]

    def_delegators :config, :home

    def initialize(args)
      super(args)
      load_data!
    end

    def [](tag)
      @data[tag]
    end

    def tags
      @data.keys
    end

    def append!(tag, info)
      File.open(config.links, "a") { |file| file << link_to_line(tag, info) }

      reload!
    end

    def remove!(tag)
      content = @data.each_with_object("") do |(_tag, info), result|
        next if _tag == tag

        result << link_to_line(_tag, info)
      end

      File.open(config.links, "w+") { |file| file << content }

      reload!
    end

    def list
      @data.each_with_object([]) do |(tag, info), result|
        result << { tag: tag }.merge(info)
      end
    end

    def load_data!
      @data = if fs.file_exists?(config.links)
                parse(File.readlines(config.links))
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

        link = link.sub(home(relative: true), home)
        path = path.sub(home(relative: true), home)

        result[tag] = { link: link, path: path }
      end
    end

    def link_to_line(tag, info)
      link, path = info.values_at(:link, :path).map do |item|
        item.sub(home, home(relative: true))
      end

      [tag, link, path].join(" :: ") + "\n"
    end
  end
end
