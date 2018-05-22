require "spec_helper"
require "support/cli_error_handler_example"

RSpec.describe Dotfiler::CLI::Commands::Init, type: :cli do
  let(:shell) { Dotfiler::Shell.new }
  let(:command) { described_class.new(command_name: "init", shell: shell) }
  let(:dotfiles_path) { test_path("dotfiles") }
  let(:options) { { path: dotfiles_path } }

  before { command.call(options) }

  it_behaves_like "a command that handles errors", :to_path, path: ""

  it "creates initial configuration files" do
    expect(test_path(".dotfiler")).to be_a_file

    config = File.read(test_path(".dotfiler"))

    expect(config).to eq("dotfiles: #{test_path("dotfiles")}")
  end

  it "creates dotfiles directory" do
    expect(test_path("dotfiles")).to be_a_directory
  end

  it "creates links file" do
    expect(test_path("dotfiles/.links")).to be_a_file
  end

  it "initializes git repo at dotfiles directory" do
    expect(test_path("dotfiles/.git")).to be_a_directory
  end

  context "when error is raised" do
    let(:dotfiles_path) { test_path('/oops\//dotfiles') }

    it "outputs error message" do
      expect(shell).to receive(:print).with_args(:error)
    end

    it "exits with code 1" do
      expect{ command.call(path: dotfiles_path, options: options) }.to terminate.with_code(1)
    end
  end

  context "with options" do
    context "no git" do
      let(:options) { { path: dotfiles_path, git: false } }

      it "does not initialize git repo" do
        expect(test_path("dotfiles/.git")).not_to be_a_directory
      end
    end
  end
end
