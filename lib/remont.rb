require 'remont/version'

require 'remont/config'
require 'remont/attribute'
require 'remont/railtie' if defined?(Rails::Railtie)
require 'remont/record_processor'
require 'remont/schema'
require 'remont/script'

module Remont
  # @yield [Remont::Config]
  def self.setup
    yield config
  end

  # @return [Remont::Config]
  def self.config
    @config ||= Config.new
  end
end
