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

  describe "#links_file_path" do
    it "returns links file path" do
      initial_setup

      expect(config.links_file_path.to_s).to eq(test_path("dotfiles/.links"))
    end
  end

  context "config data" do
    it "loads on initialization" do
      initial_setup

      expect(config[:dotfiles]).to eq(test_path("dotfiles"))
    end

    context "when config file is missing" do
      it "data is an empty hash" do
        expect(config[:dotfiles]).to be_nil
      end
    end
  end
end
