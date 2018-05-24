require "spec_helper"
require "open3"

RSpec.describe "unlink", type: :integration do
  let(:bin_path) { Pathname.new(File.expand_path(__FILE__)).join("../../..").join("exe/dotfiler").to_s }
  let(:dotfiles_path) { test_path("dotfiles") }
  let(:tag) { "test" }
  let(:file) { test_path("testrc") }
  let(:options) { "" }
  let(:command) { "#{bin_path} unlink #{tag}" }
  let(:execute) { `#{command}` }

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
