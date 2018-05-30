require "open3"

require "spec_helper"

require "support/shared/examples/initialization_guard_examples"

RSpec.describe "remove", type: :integration do
  let(:name) { "test" }
  let(:file) { test_path("testrc") }
  let(:command_name) { "remove" }
  let(:command) { "#{bin_path} #{command_name} #{name}" }

  include_context "integration"

  it_behaves_like "a command that cannot be run before Dotfiler is initialized"

  context "when initialized" do
    before do
      `#{bin_path} init #{dotfiles_path}`
      create_file(file)
      `#{bin_path} add #{name} #{file}`
    end

    specify "output" do
      expected_output = <<-EOF
#  Removing symlink (#{file})...
#  Restoring dotfile (#{dotfiles_path + "/testrc"}) to its original location (#{file})...
#  Removing '#{name}' from dotfiles...
      EOF

      expect(execute).to eq(expected_output)
    end

    context "when name does not exist" do
      let(:name) { "oops" }

      it "outputs error" do
        execute # unlink file from before block

        _output, error, status = Open3.capture3(command)

        expect(error.strip).to eq("ERROR: Dotfile with the name 'oops' does not exist")
        expect(status.exitstatus).to eq(1)
      end
    end

    context "aliases" do
      let(:command_name) { "rm" }

      it "works" do
        execute
      end
    end
  end
end
