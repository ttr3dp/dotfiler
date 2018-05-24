require "open3"

require "spec_helper"

require "support/shared/examples/initialization_guard_examples"

RSpec.describe "list", type: :integration do
  let(:links) do
    [
      { file: test_path("testrc"), tag: "test" },
      { file: test_path("otherrc"), tag: "other" }
    ]
  end
  let(:command) { "#{bin_path} list #{options}" }

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

    it "lists all links" do
      execute

      expected_output = <<-EOF
  test
    - LINK: #{test_path("testrc")}
    - PATH: #{test_path("dotfiles/testrc")}

  other
    - LINK: #{test_path("otherrc")}
    - PATH: #{test_path("dotfiles/otherrc")}

      EOF

      output, _error, _status = Open3.capture3(command)

      expect(output).to eq(expected_output)
    end

    context "with tags argument" do
      let(:options) { "tags" }

      it "lists tags only" do
        expected_output = "  test\n  other\n"

        output = Open3.capture3(command).first

        expect(output).to eq(expected_output)
      end
    end

    context "when there are no links" do
      before do
        links.each do |link|
          `#{bin_path} unlink #{link[:tag]}`
        end
      end

      it "outputs message" do
        output, _error, status = Open3.capture3(command)

        expect(output.strip).to eq("#  No dotfiles are managed at the moment")
        expect(status.exitstatus).to eq(0)
      end
    end
  end
end
