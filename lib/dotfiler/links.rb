module Dotfiler
  class Links
    include Dotfiler::Import[fs: "file_system", config: "config"]

    def self.parse(lines)
      lines.each_with_object({}) do |line, result|
        sanitized_line = line.gsub("\n", "")

        next if sanitized_line.empty?

        tag, link, path = sanitized_line.split(" :: ")

        result[tag] = { link: link, path: path }
      end
    end

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
                self.class.parse(File.readlines(config.links))
              else
                {}
              end
    end

    alias_method :reload!, :load_data!

    private

    def link_to_line(tag, info)
      link, path = info.values_at(:link, :path)

      [tag, link, path].join(" :: ") + "\n"
    end
  end
end
