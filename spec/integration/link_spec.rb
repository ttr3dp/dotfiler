require "spec_helper"
require "open3"

RSpec.describe "link", type: :integration do
  let(:bin_path) { Pathname.new(File.expand_path(__FILE__)).join("../../..").join("exe/dotfiler").to_s }
  let(:dotfiles_path) { test_path("dotfiles") }
  let(:tag) { "test" }
  let(:file) { test_path("testrc") }
  let(:options) { "" }
  let(:command) { "#{bin_path} link #{tag} #{file} #{options}" }
  let(:execute) { `#{command}` }

  before do
    `#{bin_path} init #{dotfiles_path}`
    create_file(file)
  end

  it "moves file to dotfiles dir" do
    execute

    expect(test_path("dotfiles/testrc")).to be_a_file
  end

  it "creates symlink" do
    execute

    expect(file).to be_a_symlink_of(test_path("dotfiles/testrc"))
  end

  it "appends link to links file" do
    execute

    links_file_content = File.read(test_path("dotfiles/.links"))

    expect(links_file_content).to eq(
      "test :: #{home_path("testrc")} :: #{home_path("dotfiles/testrc")}\n"
    )
  end

  context "with target option" do
    let(:options) { "-t #{test_path("dot_testrc")}" }

    it "symlinks to specified target" do
      execute

      expect(test_path("dot_testrc")).to be_a_symlink_of(test_path("dotfiles/testrc"))
    end
  end

  context "when item is already in dotfiles dir" do
    let(:file) { test_path("dotfiles/other_testrc") }

    context "without target option" do
      it "exits with error message and code 1 if target option is not provided" do
        _output, error, status = Open3.capture3(command)

        expect(error.strip).to eq(
          "ERROR: Specified file (#{file}) is already in dotfiles directory (#{test_path("dotfiles")}).\nIf you want to symlink it, please provide `--target` option"
        )
        expect(status.exitstatus).to eq(1)
      end
    end
  end

  context "when tag already exists" do
    before { execute }

    it "outputs error" do
      _output, error, status = Open3.capture3(command)

      expect(error.strip).to eq("ERROR: 'test' tag already exists")
      expect(status.exitstatus).to eq(1)
    end
  end
end
