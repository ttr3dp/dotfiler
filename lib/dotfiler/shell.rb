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
        available_answers = { "y" => { value: :yes }, "n" => { value: :no } }
        question += " [y/N] "
      end

      print(question)

      answer_key = input.gets.strip.downcase

      if (answer = available_answers[answer_key]) && answer.is_a?(Hash)
        answer.fetch(:value)
      else
        :other
      end
    end

    private

    attr_reader :output, :error, :input
  end
end
