require "open3"

require "spec_helper"

require "support/shared/examples/initialization_guard_examples"

RSpec.describe "list", type: :integration do
  let(:dotfiles) do
    [
      { file: test_path("testrc"), name: "test" },
      { file: test_path("otherrc"), name: "other" }
    ]
  end
  let(:command_name) { "list" }
  let(:command) { "#{bin_path} #{command_name} #{options}" }

  include_context "integration"

  it_behaves_like "a command that cannot be run before Dotfiler is initialized"

  context "when initialized" do
    before do
      `#{bin_path} init #{dotfiles_path}`
      dotfiles.each do |dotfile|
        create_file(dotfile[:file])
        `#{bin_path} link #{dotfile[:name]} #{dotfile[:file]}`
      end
    end

    it "lists all links" do
      expected_output = <<-EOF
  test
    - LINK: #{test_path("testrc")}
    - PATH: #{dotfiles_path("testrc")}

  other
    - LINK: #{test_path("otherrc")}
    - PATH: #{dotfiles_path("otherrc")}

      EOF

      output, _error, _status = Open3.capture3(command)

      expect(output).to eq(expected_output)
    end

    context "with names argument" do
      let(:options) { "names" }

      it "lists names only" do
        expected_output = "  test\n  other\n"

        output = Open3.capture3(command).first

        expect(output).to eq(expected_output)
      end
    end

    context "when there are no links" do
      before do
        dotfiles.each do |dotfiles|
          `#{bin_path} unlink #{dotfiles[:name]}`
        end
      end

      it "outputs message" do
        output, _error, status = Open3.capture3(command)

        expect(output.strip).to eq("#  No dotfiles are managed at the moment")
        expect(status.exitstatus).to eq(0)
      end
    end

    context "aliases" do
      let(:command_name) { "ls" }

      it "works" do
        execute
      end
    end
  end
end
