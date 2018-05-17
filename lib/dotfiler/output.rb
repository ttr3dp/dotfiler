module Dotfiler
  class Output
    attr_reader :out, :err_out

    def initialize(out: $stdout, err_out: $stderr)
      @out = out
      @err_out =  err_out
    end

    def print(content)
      out.puts("#{content}")
    end

    def info(message)
      out.puts("  # #{message}")
    end

    def error(message)
      err_out.puts("ERROR: #{message}")
    end
  end
end
