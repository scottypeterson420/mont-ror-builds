module Remont
  class Config
    # @return [Symbol]
    attr_accessor :process_timestamp_attribute

    def initialize
      @process_timestamp_attribute = :processed_at
    end
  end
end
