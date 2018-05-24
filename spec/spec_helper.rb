
require "bundler/setup"

SPEC_ROOT = File.dirname(__FILE__)
TMP_DIR = (SPEC_ROOT + "/tmp").freeze
ENV["DOTFILER_HOME"] = TMP_DIR

require "support/file_system_helper"

require "support/file_system_matchers"
require "support/terminate_matchers"

require "dotfiler"

# Must be required after "dotfiler"
require "support/cli_helper"

require "support/test_path_helper"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Use RSpec. explicitly
  config.expose_dsl_globally = false

  # Use `expect` as expectation syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Include file system helpers for easier creation of files, dirs & symlinks
  config.include FileSystemHelper

  # Include test path helper for easier path specification
  # Paths are prefixed with TMP_DIR path
  config.include TestPathHelper

  # cli helper requires necessary files
  config.include CLIHelper, type: :cli

  config.after(:each) do
    # Recreate TMP_DIR after each spec
    FileUtils.rm_rf(TMP_DIR)
    FileUtils.mkdir(TMP_DIR)
  end

  config.around(:example) do |example|
    # Prevent RSpec from terminating early because of `exit` statement
    # `exit` is used in cli commands
    begin
      example.run
    rescue SystemExit => e
      puts "Got SystemExit: #{e.status}. Ignoring..."
    end
  end

  # Dotfiler setup convenience method
  def initial_setup
    Dotfiler::CLI::Commands::Init.new(command_name: "init").call(path: test_path("dotfiles"))
  end

  # Helper method for easier links appending
  def add_links(links)
    link_list = Dotfiler.resolve["links"]

    links.each do |item|
      link_list.append!(item[:tag], link: item[:link], path: item[:path])
    end
  end
end
