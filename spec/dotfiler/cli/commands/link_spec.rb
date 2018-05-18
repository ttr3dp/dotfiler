require "spec_helper"

RSpec.describe Dotfiler::CLI::Commands::Link, type: :cli do
  let(:link) { described_class.new(command_name: "link") }
  let(:file) { test_path("foo") }

  before do
    initial_setup
    create_file(file)
    link.call(tag: "foo", path: file)
  end

  it "moves file to dotfiles dir" do
    expect(test_path("dotfiles/foo")).to be_a_file
  end

  it "creates symlink" do
    expect(file).to be_a_symlink_of(test_path("dotfiles/foo"))
  end

  it "appends link to links file" do
    links_file_content = File.read(test_path("dotfiles/.links"))

    expect(links_file_content).to eq(
      "foo :: #{home_path("foo")} :: #{home_path("dotfiles/foo")}\n"
    )
  end

  context "when tag already exists" do
    let(:shell) { Dotfiler::Shell.new }
    let(:link) { described_class.new(command_name: "link", shell: shell) }

    it "outputs error" do
      expect(shell).to receive(:print).with("'foo' tag already exists", :error)

      link.call(tag: "foo", path: "")
    end

    it "exits with code 1" do
      expect{ link.call(tag: "foo", path: "") }.to terminate.with_code(1)
    end
  end
end
