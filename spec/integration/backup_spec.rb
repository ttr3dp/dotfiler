require "spec_helper"
require "open3"

RSpec.describe "backup", type: :integration do
  let(:bin_path) { Pathname.new(File.expand_path(__FILE__)).join("../../..").join("exe/dotfiler").to_s }
  let(:dotfiles_path) { test_path("dotfiles") }
  let(:links) do
    [
      { file: test_path("testrc"), tag: "test" },
      { file: test_path("otherrc"), tag: "other" }
    ]
  end
  let(:command) { "#{bin_path} backup" }
  let(:execute) { `#{command}` }

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
