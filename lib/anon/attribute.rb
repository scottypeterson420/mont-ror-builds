module Anon
  class Attribute
    # @return [Symbol]
    attr_reader :name

    # @param [Symbol] name
    # @param [Hash] opts
    # @param [#call] :using
    # @param [Proc] processor
    def initialize(name, opts = {}, &processor)
      @name = name
      @processor = opts.fetch(:using, processor)
    end

    # @param [Object] value
    # @param [ActiveRecord::Base] record
    # @return [Object]
    def anonymize(value, record)
      processor.call(value, record)
    end

    private

    attr_reader :processor
  end
end
