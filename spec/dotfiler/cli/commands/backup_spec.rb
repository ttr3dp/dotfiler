require "spec_helper"

require "support/shared/examples/cli_error_handler_example"

RSpec.describe Dotfiler::CLI::Commands::Backup, type: :cli do
  let(:shell) { Dotfiler::Shell.new }
  let(:command) { described_class.new(command_name: "backup", shell: shell) }

  before do
    initial_setup
  end

  it_behaves_like "a command that handles errors", :to_path

  it "copies existing dotfiles dir to backup dir and removes .git subdir" do
    timestamp = Time.now
    allow(Time).to receive(:now).and_return(timestamp)

    command.call

    backup_dir = test_path(".dotfiler_backup_#{timestamp.strftime(described_class::TIMESTAMP_FORMAT)}")

    expect(backup_dir).to be_a_directory
    expect(backup_dir + "/.git").not_to be_a_directory
  end
end
