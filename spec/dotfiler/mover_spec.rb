require "spec_helper"

RSpec.describe Dotfiler::Mover do
  let(:mover) { described_class.new }

  it "moves file" do
    create_dir("foo")
    create_file("foo/bar")

    mover.call(to_test_path(test_path("foo/bar")), to_test_path(""))

    expect(file("bar")).to be_a_file
    expect(test_path("foo/bar")).not_to be_a_file
  end

  it "moves directory" do
    create_dir("foo/bar")

    mover.call(to_test_path("foo/bar"), to_test_path(""))

    expect(file("bar")).to be_a_directory
    expect(test_path("foo/bar")).not_to be_a_directory
  end

  it "returns new source path" do
    create_dir("foo")
    create_file("foo/bar")

    result = mover.call(to_test_path("foo/bar"), to_test_path(""))

    expect(result.to_s).to eq(test_path("bar"))
  end

  it "raises error if source path is invalid" do
    expect{ mover.call(to_test_path("foo"), to_test_path("bar")) }.to raise_error(
      Dotfiler::Error, /foo' does not exist/
    )
  end

  it "raises error if target path is invalid" do
    create_file("foo")

    expect{ mover.call(to_test_path("foo"), to_test_path("bar/baz")) }.to raise_error(
      Dotfiler::Error, /bar' does not exist/
    )
  end
end
