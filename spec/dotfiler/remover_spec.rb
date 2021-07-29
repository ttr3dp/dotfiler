require "spec_helper"

RSpec.describe Dotfiler::Remover do
  let(:remover) { described_class.new }

  it "removes symlinks" do
    create_file("foo")
    create_dir("bar")
    create_symlink(test_path("foo"), test_path("bar/foo"))

    expect(test_path("bar/foo")).to be_a_symlink_of(test_path("foo"))

    remover.call(to_test_path("bar/foo"))

    expect(test_path("bar/foo")).not_to be_a_symlink_of(test_path("foo"))
  end

  it "raises error if provided path is not a symlink" do
    create_file("foo")

    expect{ remover.call(to_test_path("foo")) }.to raise_error(
      "Cannot remove '#{test_path("foo")}' since it is not a symbolic link"
    )
  end
end
