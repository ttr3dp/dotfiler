require "hanami/cli"

require "dotfiler/cli/commands/command"

require "dotfiler/cli/commands/init"
require "dotfiler/cli/commands/link"
require "dotfiler/cli/commands/unlink"
require "dotfiler/cli/commands/list"
require "dotfiler/cli/commands/backup"
require "dotfiler/cli/commands/version"

module Dotfiler
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      register "init",    Init
      register "link",    Link,    aliases: ["ln"]
      register "unlink",  Unlink,  aliases: ["uln"]
      register "list",    List,    aliases: ["ls"]
      register "backup",  Backup
      register "version", Version, aliases: ["v", "-v", "--version"]
    end
  end
end

