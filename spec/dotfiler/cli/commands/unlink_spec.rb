
require "spec_helper"

RSpec.describe Dotfiler::CLI::Commands::Unlink, type: :cli do
  let(:unlink) { described_class.new(command_name: "unlink") }
  let(:file) { test_path("foo") }

  before do
    initial_setup
    create_file("foo")
    Dotfiler::CLI::Commands::Link.new(command_name: "link").call(tag: "foo", path: file)
    unlink.call(tag: "foo")
  end

  it "removes symlink" do
    expect(file).not_to be_a_symlink
  end

  it "restores file to its original path" do
    expect(file).to be_a_file
    expect(test_path("dotfiles/foo")).not_to be_a_file
  end

  it "removes link from links file" do
    expect(File.read(test_path("dotfiles/.links"))).to eq("")
  end

  context "when tag does not exist" do
    let(:output) { Dotfiler::Output.new }
    let(:unlink) { described_class.new(command_name: "unlink", output: output) }

    it "outputs error and exits" do
      expect(output).to receive(:error).with("'oops' tag doesn't exist")

      unlink.call(tag: "oops")
    end
  end
end
