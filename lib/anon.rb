require 'anon/version'

require 'anon/config'
require 'anon/attribute'
require 'anon/railtie' if defined?(Rails::Railtie)
require 'anon/record_processor'
require 'anon/schema'
require 'anon/script'

module Anon
  def self.setup
    yield config
  end

  def self.config
    @config ||= Config.new
  end
end
