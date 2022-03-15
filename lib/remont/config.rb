module Remont
  class Config
    DEFAULT_SCRIPT_PATH = 'db/remont.rb'.freeze

    # @return [Symbol]
    attr_accessor :process_timestamp_attribute

    # @return [String]
    attr_reader :script_path

    def initialize
      @process_timestamp_attribute = :processed_at
      @script_path = DEFAULT_SCRIPT_PATH
    end
  end
end
