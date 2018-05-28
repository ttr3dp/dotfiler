require "open3"

require "spec_helper"

require "support/shared/examples/initialization_guard_examples"

RSpec.describe "unlink", type: :integration do
  let(:tag) { "test" }
  let(:file) { test_path("testrc") }
  let(:command_name) { "unlink" }
  let(:command) { "#{bin_path} #{command_name} #{tag}" }

  include_context "integration"

  it_behaves_like "a command that cannot be run before Dotfiler is initialized"

  context "when initialized" do
    before do
      `#{bin_path} init #{dotfiles_path}`
      create_file(file)
      `#{bin_path} link #{tag} #{file}`
    end

    specify "output" do
      expected_output = <<-EOF
#  Removing symlink (#{file})...
#  Restoring dotfile (#{dotfiles_path + "/testrc"}) to its original location (#{file})...
#  Removing '#{tag}' from Dotfiler links...
      EOF

      expect(execute).to eq(expected_output)
    end

    context "when tag does not exist" do
      let(:tag) { "oops" }

      it "outputs error" do
        execute # unlink file from before block

        _output, error, status = Open3.capture3(command)

        expect(error.strip).to eq("ERROR: 'oops' tag doesn't exist")
        expect(status.exitstatus).to eq(1)
      end
    end

    context "aliases" do
      let(:command_name) { "uln" }

      it "works" do
        execute
      end
    end
  end
end
