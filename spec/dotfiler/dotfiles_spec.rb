require "spec_helper"

RSpec.describe Dotfiler::Dotfiles do
  let(:content) { "test :: %home%/test :: %dotfiles%/test\n" }
  let(:file) { create_file(dotfiles_file_path, content) }
  let(:dotfiles) { described_class.new }

  before do
    initial_setup
    file
  end

  describe "#find" do
    it "returns dotfile with the same name" do
      dotfiles.add!(name: "nvim", link: test_path("nvim"), path: dotfiles_path("nvim"))

      result = dotfiles.find("nvim")

      expect(result.name).to eq("nvim")
    end
  end

  describe "#names" do
    it "returns dotfile names" do
      create_dotfile("nvim")
      create_dotfile("emacs")

      expect(dotfiles.names).to eq(%w[test nvim emacs])
    end
  end

  describe "#name_taken?" do
    it "returns true if dotfile with the same name exists" do
      expect(dotfiles).to be_name_taken("test")
      expect(dotfiles).not_to be_name_taken("oops")
    end

    it "is aliased as #exists?" do
      expect(dotfiles.method(:name_taken?)).to eq(dotfiles.method(:exists?))
    end
  end

  describe "#list" do
    it "lists all dotfiles" do
      expect(dotfiles.list).to eq([
        {
          name: "test",
          link: test_path("test"),
          path: dotfiles_path("test")
        }
      ])
    end
  end

  describe "#add!" do
    it "adds new dotfile" do
      create_dotfile("nvim")

      expect(dotfiles.list).to eq([
        {
          name: "test",
          link: test_path("test"),
          path: dotfiles_path("test")
        },
        {
          name: "nvim",
          link: test_path("nvim"),
          path: dotfiles_path("nvim")
        }
      ])
    end

    it "appends new dotfiles to .dotfiles" do
      create_dotfile("nvim")

      expect(File.read(dotfiles_file_path)).to eq(<<~EOF)
        test :: %home%/test :: %dotfiles%/test
        nvim :: %home%/nvim :: %dotfiles%/nvim
      EOF
    end
  end

  describe "#remove!" do
    it "removes dotfile by name" do
      create_dotfile("nvim")

      expect(dotfiles.list).to eq([
        {
          name: "test",
          link: test_path("test"),
          path: dotfiles_path("test")
        },
        {
          name: "nvim",
          link: test_path("nvim"),
          path: dotfiles_path("nvim")
        }
      ])

      dotfiles.remove!("test")

      expect(dotfiles.list).to eq([
        {
          name: "nvim",
          link: test_path("nvim"),
          path: dotfiles_path("nvim")
        }
      ])
    end

    it "removes dotfile from .dotfiles" do
      create_dotfile("nvim")
      dotfiles.remove!("test")

      expect(File.read(dotfiles_file_path)).to eq(<<~EOF)
        nvim :: %home%/nvim :: %dotfiles%/nvim
      EOF
    end
  end

  def create_dotfile(name)
    dotfiles.add!(name: name, link: test_path(name), path: dotfiles_path(name))
  end
end
