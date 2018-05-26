require "spec_helper"

require "support/shared/examples/cli_error_handler_example"

RSpec.describe Dotfiler::CLI::Commands::Install, type: :cli do
  let(:shell) { Dotfiler::Shell.new }
  let(:command) { described_class.new(command_name: "install", shell: shell) }
  let(:dotfiles_path) { test_path("dotfiles") }
  let(:options) { { path: dotfiles_path } }
  let(:files) { 5.times.each_with_object([]) { |i, result| result << "test_#{i}" } }

  before do
    create_dir(dotfiles_path)
    links_file_content = ""
    create_files(dotfiles_path)
    files.each do |file|
      links_file_content << "#{file} :: %home%/#{file} :: %dotfiles%/#{file}\n"
    end
    create_file(dotfiles_path + "/.links", links_file_content)
  end

  it_behaves_like "a command that handles errors", :to_path, path: ""

  context "config file" do
    context "when exists" do
      before do
        create_file(test_path(".dotfiler"), "dotfiles: #{test_path("some_path")}")
        old_dotfiles_dir = create_dir(test_path("some_path"))
        create_file(test_path(old_dotfiles_dir + "/" + ".links"))
      end

      it "updates dotfiles path" do
        command.call(options)

        config = File.read(test_path(".dotfiler"))

        expect(config).to eq("dotfiles: #{dotfiles_path}")
      end
    end

    context "when does not exist" do
      it "creates configuration file" do
        command.call(options)

        expect(test_path(".dotfiler")).to be_a_file

        config = File.read(test_path(".dotfiler"))

        expect(config).to eq("dotfiles: #{dotfiles_path}")
      end
    end
  end

  it "creates symlinks" do
    command.call(options)

    files.each do |file|
      expect(test_path(file)).to be_a_symlink_of(dotfiles_path + "/" + file)
    end
  end

  context "when files already exist" do
    context "when they are not symlinks" do
      before { create_files(test_path("")) }

      it "backs them up" do
        timestamp = Time.now
        allow(Time).to receive(:now).and_return(timestamp)

        backup_dir = test_path("dotfiler_installation_backup_#{timestamp.strftime("%Y_%m_%d_%H_%M_%S")}")

        command.call(options)

        files.each do |file|
          expect(backup_dir + "/" + file).to be_a_file
        end
      end
    end

    context "when they are symlinks" do
      before { create_symlinks(dotfiles_path, test_path("")) }

      it "overwrites them" do
        command.call(options)

        backup_dir = Dir.glob(test_path(".dotfiler_installation_backup_*")).first

        expect(backup_dir).to be_nil
      end
    end
  end

  def create_files(root)
    files.each { |file| create_file(root + "/" + file) }
  end

  def create_symlinks(source_root, destination_root)
    files.each { |file| create_symlink(source_root + "/" + file, destination_root + "/" + file) }
  end
end
