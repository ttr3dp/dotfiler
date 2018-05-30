require "forwardable"

require "dotfiler/dotfile"

module Dotfiler
  class Dotfiles
    extend Forwardable
    include Enumerable

    include Dotfiler::Import["fs", "config", "to_path"]

    HOME_PLACEHOLDER     = "%home%".freeze
    DOTFILES_PLACEHOLDER = "%dotfiles%".freeze

    def_delegators :config, :home_path, :relative_home_path

    def initialize(args)
      super(args)
      load_data!
    end

    def find(name)
      @dotfiles.find { |dotfile| dotfile.name == name }
    end

    def each(&block)
      @dotfiles.each(&block)
    end

    def names
      @dotfiles.map(&:name).sort
    end

    def name_taken?(name)
      names.include?(name)
    end
    alias_method :exists?, :name_taken?

    def add!(*args)
      dotfile = Dotfile.new(*args)

      File.open(config.dotfiles_file_path.to_s, "a") do |file|
        file << dotfile_to_line(dotfile)
      end

      reload!
    end

    def remove!(name)
      content = @dotfiles.each_with_object("") do |dotfile, result|
        next if dotfile.name == name

        result << dotfile_to_line(dotfile)
      end

      File.open(config.dotfiles_file_path.to_s, "w+") { |file| file << content }

      reload!
    end

    def list
      @dotfiles.map(&:to_h)
    end

    def load_data!
      @dotfiles = if config.set?
                    parse(File.readlines(config.dotfiles_file_path.to_s))
                  else
                    {}
                  end
    end

    alias_method :reload!, :load_data!

    private

    def parse(lines)
      lines.each_with_object([]) do |line, result|
        sanitized_line = line.gsub("\n", "")

        next if sanitized_line.empty?

        name, link, path = sanitized_line.split(" :: ")

        link = link.sub(HOME_PLACEHOLDER, home_path.to_s)
        path = path.sub(DOTFILES_PLACEHOLDER, config[:dotfiles])

        result << Dotfile.new(name: name, link: link, path: path)
      end
    end

    def dotfile_to_line(dotfile)
      name, link, path = dotfile.to_h.values_at(:name, :link, :path)

      link = link.sub(home_path.to_s, HOME_PLACEHOLDER)
      path = path.sub(config[:dotfiles], DOTFILES_PLACEHOLDER)

      [name, link, path].join(" :: ") + "\n"
    end
  end
end
