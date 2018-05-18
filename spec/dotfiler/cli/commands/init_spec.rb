require "spec_helper"

RSpec.describe Dotfiler::CLI::Commands::Init, type: :cli do
  let(:output) { Dotfiler::Output.new }
  let(:init) { described_class.new(command_name: "init", output: output) }
  let(:dotfiles_path) { test_path("dotfiles") }
  let(:options) { { path: dotfiles_path } }

  before { init.call(options) }

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
      expect(output).to receive(:error)
    end

    it "exits with code 1" do
      expect{ init.call(path: dotfiles_path, options: options) }.to terminate.with_code(1)
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
