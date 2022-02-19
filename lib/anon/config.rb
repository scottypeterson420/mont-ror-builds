module Anon
  class Config
    DEFAULT_SCRIPT_PATH = 'db/anon.rb'.freeze

    # @return [Symbol]
    attr_accessor :anonymization_attribute

    # @return [String]
    attr_accessor :script_path

    def initialize
      @anonymization_attribute = :anonymized_at
      @script_path = DEFAULT_SCRIPT_PATH
    end
  end
end
