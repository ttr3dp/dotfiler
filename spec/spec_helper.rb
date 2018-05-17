require "bundler/setup"
require "support/file_system_matchers"
require "support/file_system_helper"

require "support/terminate_matchers"

require "dotfiler"

require "support/cli_helper"

SPEC_ROOT = File.dirname(__FILE__)
TMP_DIR = (SPEC_ROOT + "/tmp").freeze

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Use RSpec. explicitly
  config.expose_dsl_globally = false

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FileSystemHelper
  config.include CLIHelper, type: :cli

  config.before(:each) do
    allow(Dir).to receive(:home).and_return(TMP_DIR)
  end

  config.after(:each) do
    system("rm", "-rf", TMP_DIR)
    system("mkdir", TMP_DIR)
  end

  config.around(:example) do |ex|
    begin
      ex.run
    rescue SystemExit => e
      puts "Got SystemExit: #{e.inspect}. Ignoring"
    end
  end

  def test_path(path = nil)
    pathname = Pathname.new(TMP_DIR)

    pathname.join(path).to_s
  end


  def initial_setup
    require "hanami/cli"
    require "dotfiler/cli/commands/init"

    Dotfiler::CLI::Commands::Init.new(command_name: "init").call(path: test_path("dotfiles"))
  end

  def add_links(links)
    link_list = Dotfiler.resolve["links"]

    links.each do |item|
      link_list.append!(item[:tag], link: item[:link], path: item[:path])
    end
  end

  def config
    Dotfiler.resolve["config"]
  end
end
