RSpec.shared_examples "a command that handles errors" do |method_name, *args|
  it "rescues dotfiler error and outputs it before termination" do
    allow(command).to receive(method_name).and_raise(Dotfiler::Error, "dotfiler message")
    expect(shell).to receive(:terminate).with(:error, message: "dotfiler message")

    command.call(*args)
  end

  it "rescues errno error and outputs it before termination" do
    allow(command).to receive(method_name).and_raise(Errno.const_get(Errno.constants.sample), "errno message")

    expect(shell).to receive(:terminate).with(:error, message: /errno message/)

    command.call(*args)
  end
end
