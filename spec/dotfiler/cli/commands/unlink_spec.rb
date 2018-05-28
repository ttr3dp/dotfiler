require "spec_helper"

require "support/shared/examples/cli_error_handler_example"

RSpec.describe Dotfiler::CLI::Commands::Unlink, type: :cli do
  let(:shell) { Dotfiler::Shell.new }
  let(:command) { described_class.new(command_name: "unlink", shell: shell) }
  let(:file) { test_path("foo") }

  before do
    initial_setup
    create_file("foo")
    Dotfiler::CLI::Commands::Link.new(command_name: "link").call(tag: "foo", path: file)
    command.call(tag: "foo")
  end

  it_behaves_like "a command that handles errors", :links, tag: "bar"

  it "removes symlink" do
    expect(file).not_to be_a_symlink
  end

  it "restores file to its original path" do
    expect(file).to be_a_file
    expect(dotfiles_path("foo")).not_to be_a_file
  end

  it "removes link from links file" do
    expect(File.read(dotfiles_path(".links"))).to eq("")
  end

  context "when tag does not exist" do
    it "outputs error" do
      expect(shell).to receive(:print).with("'oops' tag doesn't exist", :error)
      command.call(tag: "oops")
    end

    it "exits with code 1" do
      expect{ command.call(tag: "oops") }.to terminate.with_code(1)
    end
  end
end
