require "open3"

require "spec_helper"

require "support/shared/examples/initialization_guard_examples"

RSpec.describe "backup", type: :integration do
  let(:dotfiles) do
    [
      { file: test_path("testrc"), name: "testrc" },
      { file: test_path("otherrc"), name: "otherrc" }
    ]
  end
  let(:command) { "#{bin_path} backup" }

  include_context "integration"

  it_behaves_like "a command that cannot be run before Dotfiler is initialized"

  context "when initialized" do
    before do
      `#{bin_path} init #{dotfiles_path}`
      dotfiles.each do |dotfile|
        create_file(dotfile[:file])
        `#{bin_path} add #{dotfile[:file]}`
      end
    end

    specify "output" do
      expect(execute).to include("Backing up dotfiles directory (#{dotfiles_path}) to #{test_path(".dotfiler_backup_")}")

      backup_dir = Dir.glob(test_path(".dotfiler_backup_*")).first
      expect(Dir.entries(backup_dir)).to match_array([".", "..", ".dotfiles", "otherrc"])
    end
  end
end
