require "open3"

require "spec_helper"

require "support/shared/examples/initialization_guard_examples"

RSpec.describe "backup", type: :integration do
  let(:links) do
    [
      { file: test_path("testrc"), tag: "test" },
      { file: test_path("otherrc"), tag: "other" }
    ]
  end
  let(:command) { "#{bin_path} backup" }

  include_context "integration"

  it_behaves_like "a command that cannot be run before Dotfiler is initialized"

  context "when initialized" do
    before do
      `#{bin_path} init #{dotfiles_path}`
      links.each do |link|
        create_file(link[:file])
        `#{bin_path} link #{link[:tag]} #{link[:file]}`
      end
    end

    it "copies existing dotfiles dir to backup dir and removes .git subdir" do
      output = execute

      expect(output).to include("Backing up dotfiles directory (#{dotfiles_path}) to #{test_path(".dotfiler_backup_")}")

      backup_dir = Dir.glob(test_path(".dotfiler_backup_*")).first

      expect(backup_dir).not_to be_nil
      expect(Dir.entries(backup_dir)).to eq([".", "..", ".links", "testrc", "otherrc"])
    end
  end
end
