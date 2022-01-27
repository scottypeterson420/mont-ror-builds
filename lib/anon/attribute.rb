module Anon
  class Attribute
    # @return [Symbol]
    attr_reader :name

    # @param [Symbol] name
    # @param [Proc] processor
    def initialize(name, &processor)
      @name = name
      @processor = processor
    end

    # @param [Object] value
    # @param [ActiveRecord::Base] record
    # @return [Object]
    def anonymize(value, record)
      @processor.call(value, record)
    end
  end
end
