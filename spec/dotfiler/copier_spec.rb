require "spec_helper"

RSpec.describe Dotfiler::Copier do
  let(:copier) { described_class.new }

  it "copies file " do
    create_dir("foo")
    create_file("foo/bar")

    expect(test_path("foo/bar")).to be_a_file

    copier.call(test_path("foo/bar"), test_path(""))

    expect(file("bar")).to be_a_file
    expect(test_path("foo/bar")).to be_a_file
  end

  it "copies directory" do
    create_dir("foo/bar")

    expect(test_path("foo/bar")).to be_a_directory

    copier.call(test_path("foo/bar"), test_path(""))

    expect(file("bar")).to be_a_directory
    expect(test_path("foo/bar")).to be_a_directory
  end

  it "copies directory recursively while keeping the original name" do
    create_dir("foo")
    create_file("foo/bar")
    create_dir("foo/baz")
    create_file("foo/baz/qux")

    create_dir("copied")

    copier.call(test_path("foo"), test_path("copied"))

    expect(test_path("copied/foo")).to be_a_directory
    expect(test_path("copied/foo/bar")).to be_a_file
    expect(test_path("copied/foo/baz")).to be_a_directory
    expect(test_path("copied/foo/baz/qux")).to be_a_file
  end

  it "raises error if source path is invalid" do
    expect{ copier.call(test_path("foo"), test_path("bar")) }.to raise_error(
      Dotfiler::Error, /foo' does not exist/
    )
  end

  it "raises error if target path is invalid" do
    create_file("test")

    expect{ copier.call(test_path("test"), test_path("bar/baz")) }.to raise_error(
      Dotfiler::Error, /bar' does not exist/
    )
  end
end
