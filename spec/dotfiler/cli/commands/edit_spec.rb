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
      { tag: tag, link: test_path(tag), path: dotfiles_path(tag) }
    ])
  end

  it_behaves_like "a command that handles errors", :links, { tag: "" }

  it "opens the dotfile in $EDITOR" do
    allow(command).to receive(:default_editor).and_return("vim")

    expect(fs).to receive(:execute).with("vim", "#{dotfiles_path("test")}")

    command.call(args)
  end

  context "when tag does not exist" do
    it "terminates with code 1 and error message" do
      expect(shell).to receive(:terminate).with(:error, message: "Tag 'oops' not found").and_call_original

      expect(command.call(tag: "oops")).to terminate.with_code(1)
    end
  end

  context "editor" do
    context "when $EDITOR is not set" do
      it "terminates with code 1 and error message" do
        allow(command).to receive(:default_editor).and_return(nil)

        expect(shell).to receive(:terminate).with(
          :error,
          message: "Editor is not specified. Either set the '$EDITOR' environment variable or provide '--with' option"
        ).and_call_original

        expect(command.call(args)).to terminate.with_code(1)
      end
    end

    context "when --with option is provided" do
      let(:args) { { tag: tag, with: "emacs" } }

      it "uses the specified editor" do
        allow(command).to receive(:default_editor).and_return(nil)

        expect(fs).to receive(:execute).with("emacs", "#{dotfiles_path("test")}")

        command.call(args)
      end
    end
  end
end
