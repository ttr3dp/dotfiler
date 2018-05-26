require "open3"

require "spec_helper"

RSpec.describe "install", type: :integration do
  let(:command_name) { "install" }
  let(:dotfiles_path) { test_path("dotfiles") }
  let(:command) { "#{bin_path} #{command_name} #{dotfiles_path}" }
  let(:files) { 5.times.each_with_object([]) { |i, result| result << "test_#{i}" } }

  include_context "integration"

  before do
    create_dir(dotfiles_path)
    create_files(dotfiles_path)

    links_file_content = ""
    files.each do |file|
      links_file_content << "#{file} :: %home%/#{file} :: %dotfiles%/#{file}\n"
    end

    create_file(dotfiles_path + "/.links", links_file_content)
  end

  it "installs dotfiles" do
    output = execute

    expected_output = files.each_with_object([]) do |file, result|
      result << "#  Symlinking dotfile (#{dotfiles_path + "/" + file}) to #{test_path(file)}...\n"
    end.join("")

    files.each do |file|
      expect(test_path(file)).to be_a_symlink_of(dotfiles_path + "/" + file)
    end

    expect(output).to eq(expected_output)
  end

  context "when files already exist" do
    context "when they are not symlinks" do
      let(:backup_dir) { Dir.glob(test_path("dotfiler_installation_backup_*")).first }

      before { create_files(test_path("")) }

      it "backs them up" do
        execute

        files.each do |file|
          expect(backup_dir + "/" + file).to be_a_file

          expect(test_path(file)).to be_a_symlink_of(dotfiles_path + "/" + file)
        end
      end
    end

    context "when they are symlinks" do
      before { create_symlinks(dotfiles_path, test_path("")) }

      it "overwrites them" do
        execute

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
