require "spec_helper"

RSpec.describe Dotfiler::CLI::Commands::Backup, type: :cli do
  let(:backup) { described_class.new(command_name: "backup") }

  before do
    initial_setup
  end

  it "copies existing dotfiles dir to backup dir and removes .git subdir" do
    timestamp = Time.now
    allow(Time).to receive(:now).and_return(timestamp)

    backup.call

    backup_dir = test_path(".dotfiler_backup_#{timestamp.strftime(described_class::TIMESTAMP_FORMAT)}")

    expect(backup_dir).to be_a_directory
    expect(backup_dir + "/.git").not_to be_a_directory
  end
end
