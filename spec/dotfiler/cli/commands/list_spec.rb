require "spec_helper"

RSpec.describe Dotfiler::CLI::Commands::List, type: :cli do

  let(:shell) { Dotfiler::Shell.new }
  let(:list) { described_class.new(command_name: "list", shell: shell) }

  before do
    initial_setup
    links = %w(foo bar baz).each_with_object([]) do |dot, result|
      result << { tag: dot, link: test_path(dot), path: test_path("dotfiles/#{dot}") }
    end
    add_links(links)
  end

  it "lists all links" do
    expected_output = <<-EOF
  foo
    - LINK: #{test_path("foo")}
    - PATH: #{test_path("dotfiles/foo")}

  bar
    - LINK: #{test_path("bar")}
    - PATH: #{test_path("dotfiles/bar")}

  baz
    - LINK: #{test_path("baz")}
    - PATH: #{test_path("dotfiles/baz")}

    EOF

    expect(shell).to receive(:print).with(expected_output)

    list.call
  end

  it "lists tags only" do
    expected_output = "  foo\n  bar\n  baz\n"

    expect(shell).to receive(:print).with(expected_output)

    list.call(tags: "tags")
  end

  context "when there are no links" do
    before do
      File.open(test_path("dotfiles/.links"), "w+") { |f| f << "" }
    end

    it "outputs message" do
      expect(shell).to receive(:print).with("No dotfiles are managed at the moment", :info)

      list.call
    end

    it "exits with code 0" do
      expect{ list.call }.to terminate.with_code(0)
    end
  end
end
