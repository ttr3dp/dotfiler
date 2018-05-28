require "spec_helper"

RSpec.describe Dotfiler::Links do
  let(:file_path) { "dotfiles/.links" }
  let(:content) { "test :: %home%/test :: %dotfiles%/test\n" }
  let(:file) { create_file(file_path, content) }
  let(:links) { described_class.new }

  before do
    initial_setup
    file
  end

  it "lists all dotfiles" do
    expect(links.list).to eq([
      {
        tag: "test",
        link: test_path("test"),
        path: dotfiles_path("test")
      }
    ])
  end

  it "appends new links" do
    links.append!("nvim", tag: "nvim", link: test_path("nvim"), path: dotfiles_path("nvim"))

    expect(links.list).to eq([
      {
        tag: "test",
        link: test_path("test"),
        path: dotfiles_path("test")
      },
      {
        tag: "nvim",
        link: test_path("nvim"),
        path: dotfiles_path("nvim")
      }
    ])
  end

  it "removes links by tag" do
    links.append!("nvim", link: test_path("nvim"), path: dotfiles_path("nvim"))

    expect(links.list).to eq([
      {
        tag: "test",
        link: test_path("test"),
        path: dotfiles_path("test")
      },
      {
        tag: "nvim",
        link: test_path("nvim"),
        path: dotfiles_path("nvim")
      }
    ])

    links.remove!("test")
    expect(links.list).to eq([
      {
        tag: "nvim",
        link: test_path("nvim"),
        path: dotfiles_path("nvim")
      }
    ])
  end
end
