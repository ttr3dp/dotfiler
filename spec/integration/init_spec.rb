require "spec_helper"
require "open3"

RSpec.describe "init", type: :integration do
  let(:bin_path) { Pathname.new(File.expand_path(__FILE__)).join("../../..").join("exe/dotfiler").to_s }
  let(:dotfiles_path) { test_path("dotfiles") }
  let(:options) { "" }
  let(:command) { "#{bin_path} init #{dotfiles_path} #{options}" }
  let(:execute) { `#{command}` }

  it "creates initial configuration files" do
    execute

    expect(test_path(".dotfiler")).to be_a_file

    config = File.read(test_path(".dotfiler"))

    expect(config).to eq("dotfiles: #{test_path("dotfiles")}")
  end

  it "creates dotfiles directory" do
    execute

    expect(test_path("dotfiles")).to be_a_directory
  end

  it "creates links file" do
    execute

    expect(test_path("dotfiles/.links")).to be_a_file
  end

  it "initializes git repo at dotfiles directory" do
    execute

    expect(test_path("dotfiles/.git")).to be_a_directory
  end

  it "outputs steps info" do
    expected_output = <<~EOF
      #  Creating config file (#{test_path(".dotfiler")})...
      #  Creating dotfiles directory (#{dotfiles_path})...
      #  Creating links file (#{dotfiles_path + "/.links"})...
      #  Initialized empty Git repository in #{dotfiles_path + "/.git/"}
    EOF

    expect(execute).to eq(expected_output)
  end

  context "with options" do
    context "--no-git" do
      let(:options) { "--no-git" }

      it "skips git repo initialization" do
        execute

        expect(test_path("dotfiles/.git")).not_to be_a_directory
      end
    end
  end

  context "when already initialized" do
    it "allows you to overwrite config file" do
      overwrite_message = "Config file (#{test_path(".dotfiler")}) already exists. Would you like to overwrite it? [y/N]"
      create_message    = "#  Creating config file (#{test_path(".dotfiler")})..."

      execute

      lines = capture_output_lines(input_data: "y")

      expect(lines[0]).to eq(overwrite_message)
      expect(lines[1]).to eq(create_message)
    end

    it "allows you to overwrite dotfiles dir" do
      overwrite_message = "Dotfiles directory (#{test_path("dotfiles")}) already exists. Would you like to overwrite it? [y/N]"
      remove_message    = "#  Removing existing dotfiles directory (#{test_path("dotfiles")})..."
      create_message    = "#  Creating dotfiles directory (#{test_path("dotfiles")})..."

      execute

      lines = capture_output_lines(input_data: "n\ny")

      expect(lines[1]).to eq(overwrite_message)
      expect(lines[2]).to eq(remove_message)
      expect(lines[3]).to eq(create_message)
    end

    it "allows you to overwrite links file" do
      overwrite_message = "Links file (#{test_path("dotfiles/.links")}) already exists. Would you like to overwrite it? [y/N]"
      create_message    = "#  Creating links file (#{test_path("dotfiles/.links")})..."

      execute

      lines = capture_output_lines(input_data: "n\nn\ny")

      expect(lines[2]).to eq(overwrite_message)
      expect(lines[3]).to eq(create_message)
    end

    it "allows you to reinitialize git repo" do
      overwrite_message = "Dotfiles dir (#{test_path("dotfiles")}) is already a git repository. Would you like to reinitialize it? [y/N]"
      create_message    = "#  Reinitialized existing Git repository in #{test_path("dotfiles/.git/")}"

      execute

      lines = capture_output_lines(input_data: "n\nn\nn\ny")

      expect(lines[3]).to eq(overwrite_message)
      expect(lines[4]).to eq(create_message)
    end

    def capture_output_lines(opts = {})
      Open3.capture3(command, stdin_data: opts[:input_data]).first.split("\n").map(&:strip)
    end
  end
end
