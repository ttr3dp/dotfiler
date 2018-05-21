module Dotfiler
  class Shell
    TERMINATION_CODES = {
      clean: 0,
      info:  0,
      error: 1
    }.freeze

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
        output.puts("#  #{content}")
      else
        output.puts("#{content}")
      end
    end

    def prompt(text, available_answers = {})
      question = text

      if available_answers.any?
        question += "\n\n"
        available_answers.each { |key, details| question += "  #{key}) #{details[:desc]}\n" }
      else
        available_answers = default_prompt_answer
        question += " [y/N] "
      end

      print(question)

      answer_key = input.gets.strip.downcase

      return :other unless available_answers.key?(answer_key)

      available_answers[answer_key].fetch(:value)
    end

    def terminate(type, message: nil)
      print(message, type) unless message.nil?
      exit(TERMINATION_CODES[type])
    end

    private

    attr_reader :output, :error, :input

    def default_prompt_answer
      { "y" => { value: :yes }, "n" => { value: :no } }
    end

  end
end
