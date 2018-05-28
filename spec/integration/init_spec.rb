require "open3"

require "spec_helper"

RSpec.describe "init", type: :integration do
  let(:command) { "#{bin_path} init #{dotfiles_path} #{options}" }

  include_context "integration"


  specify "output" do
    expected_output = <<~EOF
      #  Creating config file (#{test_path(".dotfiler")})...
      #  Creating dotfiles directory (#{dotfiles_path})...
      #  Creating dotfiles file (#{dotfiles_file_path})...
      #  Initialized empty Git repository in #{dotfiles_path(".git") + "/"}
    EOF

    expect(execute).to eq(expected_output)
  end

  context "with options" do
    context "--no-git" do
      let(:options) { "--no-git" }

      it "skips git repo initialization" do
        expect(execute).not_to include("#  Initialized empty Git repository in #{dotfiles_path(".git")}")
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
      overwrite_message = "Dotfiles directory (#{dotfiles_path}) already exists. Would you like to overwrite it? [y/N]"
      remove_message    = "#  Removing existing dotfiles directory (#{dotfiles_path})..."
      create_message    = "#  Creating dotfiles directory (#{dotfiles_path})..."

      execute

      lines = capture_output_lines(input_data: <<~EOF)
        n
        y
      EOF

      expect(lines[1]).to eq(overwrite_message)
      expect(lines[2]).to eq(remove_message)
      expect(lines[3]).to eq(create_message)
    end

    it "allows you to overwrite dotfiles file" do
      overwrite_message = "Dotfiles file (#{dotfiles_file_path}) already exists. Would you like to overwrite it? [y/N]"
      create_message    = "#  Creating dotfiles file (#{dotfiles_file_path})..."

      execute

      lines = capture_output_lines(input_data: <<~EOF)
        n
        n
        y
      EOF

      expect(lines[2]).to eq(overwrite_message)
      expect(lines[3]).to eq(create_message)
    end

    it "allows you to reinitialize git repo" do
      overwrite_message = "Dotfiles dir (#{dotfiles_path}) is already a git repository. Would you like to reinitialize it? [y/N]"
      create_message    = "#  Reinitialized existing Git repository in #{dotfiles_path(".git/")}"

      execute

      lines = capture_output_lines(input_data: <<~EOF)
        n
        n
        n
        y
      EOF

      expect(lines[3]).to eq(overwrite_message)
      expect(lines[4]).to eq(create_message)
    end

    def capture_output_lines(opts = {})
      Open3.capture3(command, stdin_data: opts[:input_data]).first.split("\n").map(&:strip)
    end
  end
end
