require "open3"

RSpec.shared_examples "a command that cannot be run before Dotfiler is initialized" do
  context "when uninitialized" do
    it "outputs error" do
      _output, error, status = Open3.capture3(command)

      expect(error.strip).to eq("ERROR: Dotfiler needs to be setup first. Check `dotfiler init -h`")
      expect(status.exitstatus).to eq(1)
    end
  end
end
