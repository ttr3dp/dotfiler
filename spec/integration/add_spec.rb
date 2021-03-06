require "open3"

require "spec_helper"

require "support/shared/examples/initialization_guard_examples"

RSpec.describe "add", type: :integration do
  let(:name) { "testrc" }
  let(:file) { test_path("testrc") }
  let(:command_name) { "add" }
  let(:command) { "#{bin_path} #{command_name} #{file} #{options}" }

  include_context "integration"

  it_behaves_like "a command that cannot be run before Dotfiler is initialized"

  context "when initialized" do
    before do
      `#{bin_path} init #{dotfiles_path}`
      create_file(file)
    end

    specify "output" do
      expected_output = <<-EOF
#  Moving #{file} to dotfiles directory (#{dotfiles_path})...
#  Symlinking dotfile (#{dotfiles_path("testrc")}) to #{file}...
#  Adding #{name} to dotfiles...
      EOF

      expect(execute).to eq(expected_output)
    end

    context "with target option" do
      let(:options) { "-t #{test_path("dot_testrc")}" }

      it "symlinks to specified target" do
        expect(execute.split("\n")[1]).to eq(
          "#  Symlinking dotfile (#{dotfiles_path("testrc")}) to #{test_path("dot_testrc")}..."
        )
      end
    end

    context "with name option" do
      let(:options) { "-n custom_name" }

      it "assigns passed name to dotfile" do
        expect(execute).to include("#  Adding custom_name to dotfiles...")
      end
    end

    context "when item is already in dotfiles dir" do
      let(:file) { dotfiles_path("other_testrc") }

      context "without target option" do
        it "exits with error message and code 1 if target option is not provided" do
          _output, error, status = Open3.capture3(command)

          expect(error.strip).to eq(
            "ERROR: Specified file (#{file}) is already in dotfiles directory (#{dotfiles_path}).\nIf you want to symlink it, please provide `--target` option"
          )
          expect(status.exitstatus).to eq(1)
        end
      end
    end

    context "when name already exists" do
      before { execute }

      it "outputs error" do
        _output, error, status = Open3.capture3(command)

        expect(error.strip).to eq("ERROR: Dotfile with the name '#{name}' already exists")
        expect(status.exitstatus).to eq(1)
      end
    end

    context "aliases" do
      let(:command_name) { "a" }

      it "works" do
        execute
      end
    end
  end
end
