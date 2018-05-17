require "spec_helper"

RSpec.describe Dotfiler::Links do
  let(:file_path) { "dotfiles/.links" }
  let(:content) { "test :: #{test_path("test")} :: #{test_path("dotfiles/test")}\n" }
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
        path: test_path("dotfiles/test")
      }
    ])
  end

  it "appends new links" do
    links.append!("nvim", tag: "nvim", link: test_path("nvim"), path: test_path("dotfiles/nvim"))

    expect(links.list).to eq([
      {
        tag: "test",
        link: test_path("test"),
        path: test_path("dotfiles/test")
      },
      {
        tag: "nvim",
        link: test_path("nvim"),
        path: test_path("dotfiles/nvim")
      }
    ])
  end

  it "removes links by tag" do
    links.append!("nvim", link: test_path("nvim"), path: test_path("dotfiles/nvim"))

    expect(links.list).to eq([
      {
        tag: "test",
        link: test_path("test"),
        path: test_path("dotfiles/test")
      },
      {
        tag: "nvim",
        link: test_path("nvim"),
        path: test_path("dotfiles/nvim")
      }
    ])

    links.remove!("test")
    expect(links.list).to eq([
      {
        tag: "nvim",
        link: test_path("nvim"),
        path: test_path("dotfiles/nvim")
      }
    ])
  end
end
