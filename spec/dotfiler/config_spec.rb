require "spec_helper"

RSpec.describe Dotfiler::Config do
  let(:config) { Dotfiler::Config.new }

  describe "#file_path" do
    it "returns config file path" do
      expect(config.file_path.to_s).to eq(test_path(".dotfiler"))
    end
  end

  describe "#home_path" do
    it "returns home path" do
      expect(config.home_path.to_s).to eq(test_path(""))
    end
  end

  describe "#dotfiles_file_path" do
    it "returns dotfiles file path" do
      initial_setup

      expect(config.dotfiles_file_path.to_s).to eq(dotfiles_file_path)
    end
  end

  describe "#set" do
    it "returns true if file exists, false otherwise" do
      expect(config).not_to be_set

      initial_setup

      expect(config).to be_set
    end
  end

  describe "#update!" do
    it "updates config" do
      initial_setup
      config.update!(dotfiles: "changed_dotfiles")

      expect(config[:dotfiles]).to eq("changed_dotfiles")
    end
  end

  context "config data" do
    it "loads on initialization" do
      initial_setup

      expect(config[:dotfiles]).to eq(dotfiles_path)
    end

    context "when config file is missing" do
      it "data is an empty hash" do
        expect(config[:dotfiles]).to be_nil
      end
    end
  end
end
