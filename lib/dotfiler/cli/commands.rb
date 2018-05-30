require "hanami/cli"

require "dotfiler/cli/commands/command"

require "dotfiler/cli/commands/init"
require "dotfiler/cli/commands/install"
require "dotfiler/cli/commands/add"
require "dotfiler/cli/commands/unlink"
require "dotfiler/cli/commands/list"
require "dotfiler/cli/commands/edit"
require "dotfiler/cli/commands/backup"
require "dotfiler/cli/commands/version"

module Dotfiler
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      register "init",    Init
      register "install", Install
      register "add",     Add,     aliases: ["a"]
      register "unlink",  Unlink,  aliases: ["uln"]
      register "list",    List,    aliases: ["ls"]
      register "edit",    Edit,    aliases: ["e"]
      register "backup",  Backup
      register "version", Version, aliases: ["v", "-v", "--version"]

      %w(add unlink list edit backup).each do |cmd|
        before(cmd) do
          unless Dotfiler.resolve[:config].set?
            $stderr.puts("ERROR: Dotfiler needs to be setup first. Check `dotfiler init -h`")
            exit(1)
          end
        end
      end
    end
  end
end

