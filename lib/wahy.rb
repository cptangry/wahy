require_relative "wahy/version"
require_relative "wahy/parser"
require_relative "wahy/cli"

module Wahy
  class Error < StandardError; end

  # Extend the parser methods so they can be called directly on Wahy module
  # e.g. Wahy.new_data('eng')
  extend Parser
end
