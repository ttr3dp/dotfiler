require "spec_helper"

RSpec.describe "version", type: :integration do
  let(:expected_output) { "dotfiler #{Dotfiler::VERSION}\n" }

  include_context "integration"

  it "outputs version" do
    %w(version v -v --version).each do |cmd|
      expect(`#{bin_path} #{cmd}`).to eq(expected_output)
    end
  end
end
