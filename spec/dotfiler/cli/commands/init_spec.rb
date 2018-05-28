require "spec_helper"

require "support/shared/examples/cli_error_handler_example"

RSpec.describe Dotfiler::CLI::Commands::Init, type: :cli do
  let(:shell) { Dotfiler::Shell.new }
  let(:command) { described_class.new(command_name: "init", shell: shell) }
  let(:options) { { path: dotfiles_path } }

  before { command.call(options) }

  it_behaves_like "a command that handles errors", :to_path, path: ""

  it "creates initial configuration files" do
    expect(test_path(".dotfiler")).to be_a_file

    config = File.read(test_path(".dotfiler"))

    expect(config).to eq("dotfiles: #{dotfiles_path}")
  end

  it "creates dotfiles directory" do
    expect(dotfiles_path).to be_a_directory
  end

  it "creates links file" do
    expect(dotfiles_path(".links")).to be_a_file
  end

  it "initializes git repo at dotfiles directory" do
    expect(dotfiles_path(".git")).to be_a_directory
  end

  context "with options" do
    context "no git" do
      let(:options) { { path: dotfiles_path, git: false } }

      it "does not initialize git repo" do
        expect(dotfiles_path(".git")).not_to be_a_directory
      end
    end
  end
end
