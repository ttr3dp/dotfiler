require "dotfiler/version"

module Dotfiler
  Error = Class.new(StandardError)

  def self.resolve
    @_container ||= Container
  end
end

require "dotfiler/container"
