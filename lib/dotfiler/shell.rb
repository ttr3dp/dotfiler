module Dotfiler
  class Shell
    def initialize(output: $stdout, input: $stdin, error: $stderr)
      @output = output
      @error = error
      @input = input
    end

    def print(content, type = nil)
      case type
      when :error
        error.puts("ERROR: #{content}")
      when :info
        output.puts("  # #{content}")
      else
        output.puts("#{content}")
      end
    end

    private

    attr_reader :output, :error, :input
  end
end
