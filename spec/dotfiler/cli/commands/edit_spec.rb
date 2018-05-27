require "spec_helper"

require "support/shared/examples/cli_error_handler_example"

RSpec.describe Dotfiler::CLI::Commands::Edit, type: :cli do
  let(:fs) { Dotfiler::FileSystem.new }
  let(:shell) { Dotfiler::Shell.new }
  let(:tag) { "test" }
  let(:args) { { tag: tag } }
  let(:command) { described_class.new(command_name: "edit", shell: shell, fs: fs) }

  before do
    initial_setup
    add_links([
      { tag: tag, link: test_path(tag), path: test_path("dotfiles/#{tag}") }
    ])
  end

  it_behaves_like "a command that handles errors", :links, { tag: "" }

  it "opens the editor" do
    allow(command).to receive(:editor).and_return("vim")

    expect(fs).to receive(:execute).with("vim", "#{test_path("dotfiles/test")}")

    command.call(args)
  end

  context "when tag does not exist" do
    it "terminates with code 1 and error message" do
      expect(shell).to receive(:terminate).with(:error, message: "Tag 'oops' not found").and_call_original

      expect(command.call(tag: "oops")).to terminate.with_code(1)
    end
  end

  context "when editor is not set" do
    it "terminates with code 1 and error message" do
      allow(command).to receive(:editor).and_return(nil)

      expect(shell).to receive(:terminate).with(
        :error,
        message: "Editor is not configured. Please set $EDITOR environment variable on your system").and_call_original

      expect(command.call(args)).to terminate.with_code(1)
    end
  end
end
