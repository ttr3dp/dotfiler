RSpec.shared_context "integration", type: :integration do
  let(:bin_path) { Pathname.new(SPEC_ROOT).join("..").join("exe/dotfiler").to_s }
  let(:dotfiles_path) { test_path("dotfiles") }
  let(:options) { "" }
  let(:execute) { `#{command}` }
end
