require "spec_helper"

RSpec.describe Dotfiler::Symlinker do
  let(:symlinker) { described_class.new }

  it "symlinks file" do
    create_dir("foo")
    create_file("foo/bar")

    symlinker.call(to_test_path("foo/bar"), to_test_path("bar"))

    expect(file("bar")).to be_a_symlink_of(test_path("foo/bar"))
  end

  it "symlinks directory" do
    create_dir("foo/bar")

    symlinker.call(to_test_path("foo/bar"), to_test_path("bar"))

    expect(test_path("bar")).to be_a_symlink_of(test_path("foo/bar"))
  end

  it "returns new symlink path" do
    create_dir("foo")
    create_file("foo/bar")

    result = symlinker.call(to_test_path("foo/bar"), to_test_path("bar"))

    expect(result.to_s).to eq(test_path("bar"))
  end

  context "when path is taken" do
    before do
      create_dir("foo")
      create_file("foo/bar")
      create_file("foo/baz")
    end

    context "when file is symlink" do
      it "overrides the file" do
        create_symlink("foo/baz", "bar")

        expect(test_path("bar")).to be_a_symlink_of(test_path("foo/baz"))

        symlinker.call(to_test_path("foo/bar"), to_test_path("bar"))

        expect(test_path("bar")).to be_a_symlink_of(test_path("foo/bar"))
      end
    end

    context "when file is not symlink" do
      it "raises error" do
        create_file("bar")

        expect {
          symlinker.call(to_test_path("foo/bar"), to_test_path("bar"))
        }.to raise_error(Errno::EEXIST, /#{test_path("bar")}/)
      end
    end
  end

  it "raises error if source path is invalid" do
    expect{ symlinker.call(to_test_path("foo"), to_test_path("bar")) }.to raise_error(
      Dotfiler::Error, /foo' does not exist/
    )
  end

  it "raises error if symlink path is invalid" do
    create_file("foo")

    expect{ symlinker.call(to_test_path("foo"), to_test_path("bar/baz")) }.to raise_error(
      Dotfiler::Error, /bar' does not exist/
    )
  end
end
