require "open3"

require "spec_helper"

require "support/shared/examples/initialization_guard_examples"

RSpec.describe "unlink", type: :integration do
  let(:tag) { "test" }
  let(:file) { test_path("testrc") }
  let(:command) { "#{bin_path} unlink #{tag}" }

  include_context "integration"

  it_behaves_like "a command that cannot be run before Dotfiler is initialized"

  context "when initialized" do
    before do
      `#{bin_path} init #{dotfiles_path}`
      create_file(file)
      `#{bin_path} link #{tag} #{file}`
    end

    it "removes symlink" do
      execute

      expect(file).not_to be_a_symlink
    end

    it "restores file to its original path" do
      execute

      expect(file).to be_a_file
      expect(test_path("dotfiles/test")).not_to be_a_file
    end

    it "removes link from links file" do
      execute

      expect(File.read(test_path("dotfiles/.links"))).to eq("")
    end

    it "outputs info for each operation" do
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
  end
end
