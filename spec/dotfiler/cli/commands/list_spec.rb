require "spec_helper"

require "support/shared/examples/cli_error_handler_example"

RSpec.describe Dotfiler::CLI::Commands::List, type: :cli do
  let(:shell) { Dotfiler::Shell.new }
  let(:command) { described_class.new(command_name: "list", shell: shell) }

  before do
    initial_setup
    dotfiles = %w(foo bar baz).each_with_object([]) do |dot, result|
      result << { name: dot, link: test_path(dot), path: dotfiles_path("#{dot}") }
    end
    add_dotfiles(dotfiles)
  end

  it_behaves_like "a command that handles errors", :dotfiles

  it "lists all dotfiles" do
    expected_output = <<-EOF
  bar
    - LINK: #{test_path("bar")}
    - PATH: #{dotfiles_path("bar")}

  baz
    - LINK: #{test_path("baz")}
    - PATH: #{dotfiles_path("baz")}

  foo
    - LINK: #{test_path("foo")}
    - PATH: #{dotfiles_path("foo")}

    EOF

    expect(shell).to receive(:print).with(expected_output)

    command.call
  end

  it "lists names only" do
    expected_output = "  bar\n  baz\n  foo\n"

    expect(shell).to receive(:print).with(expected_output)

    command.call(names: true)
  end

  context "when there are no dotfiles" do
    before do
      File.open(dotfiles_file_path, "w+") { |f| f << "" }
    end

    it "outputs message" do
      expect(shell).to receive(:print).with("No dotfiles are managed at the moment", :info)

      command.call
    end

    it "exits with code 0" do
      expect{ command.call }.to terminate.with_code(0)
    end
  end
end
