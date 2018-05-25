require "spec_helper"

require "support/shared/examples/cli_error_handler_example"

RSpec.describe Dotfiler::CLI::Commands::Link, type: :cli do
  let(:shell) { Dotfiler::Shell.new }
  let(:command) { described_class.new(command_name: "link", shell: shell) }
  let(:file) { test_path("foo") }
  let(:tag) { "foo" }
  let(:path) { file }
  let(:options) { {} }
  let(:args) { { tag: tag, path: path }.merge(options) }

  before do
    initial_setup
    create_file(file)
    command.call(args)
  end

  it_behaves_like "a command that handles errors", :to_path, tag: "oops", path: ""

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

  context "with target option" do
    let(:options) { { target: test_path("dot_foo") } }

    it "symlinks to specified target" do
      expect(test_path("dot_foo")).to be_a_symlink_of(test_path("dotfiles/foo"))
    end
  end

  context "when item is already in dotfiles dir" do
    let(:file) { test_path("dotfiles/bar") }

    context "without target option" do
      it "exits with error message and code 1 if target option is not provided" do
        expect(shell).to receive(:terminate).with(
          :error,
          message: "Specified file (#{file}) is already in dotfiles directory (#{test_path("dotfiles")}).\nIf you want to symlink it, please provide `--target` option"
        )
        expect{ command.call(args) }.to terminate.with_code(1)
      end
    end
  end

  context "when tag already exists" do
    it "outputs error" do
      expect(shell).to receive(:print).with("'foo' tag already exists", :error)

      command.call(args)
    end

    it "exits with code 1" do
      expect{ command.call(tag: "foo", path: "") }.to terminate.with_code(1)
    end
  end

  context "when dotfile already exists" do
    let(:input) { StringIO.new }
    let(:output) { StringIO.new }
    let(:shell) { Dotfiler::Shell.new(input: input, output: output) }

    before do
      create_file(test_path("dotfiles/test"), "old test")
      create_file(test_path("test"), "new test")
    end

    it "prompts for continuation" do
      available_options = {
        "1" => { value: :overwrite,            desc: "Overwrite it" },
        "2" => { value: :backup_and_overwrite, desc: "Backup and overwrite it" },
        "3" => { value: :cancel,               desc: "Cancel"}
      }

      expect(shell).to receive(:prompt).with(
        "Dotfile (#{test_path("dotfiles/test")}) already exists.\nWould you like to:",
        available_options
      )

      command.call(tag: "test", path: test_path("test"))
    end

    context "answer" do
      context "1" do
        it "overwrites dotfile" do
          allow(input).to receive(:gets).and_return("1")

          command.call(tag: "test", path: test_path("test"))

          expect(File.read(test_path("dotfiles/test"))).to eq("new test")
        end
      end

      context "2" do
        it "backs up and overwrites dotfile" do
          allow(input).to receive(:gets).and_return("2")

          command.call(tag: "test", path: test_path("test"))

          expect(File.read(test_path("dotfiles/test_old"))).to eq("old test")
          expect(File.read(test_path("dotfiles/test"))).to eq("new test")
        end
      end

      context "3" do
        it "cancels" do
          allow(input).to receive(:gets).and_return("3")

          expect(command.call(tag: "test", path: test_path("test"))).to terminate.with_code(0)
        end
      end

      context "default" do
        it "cancels" do
          allow(input).to receive(:gets).and_return("oops")

          expect(command.call(tag: "test", path: test_path("test"))).to terminate.with_code(0)
        end
      end
    end
  end
end
