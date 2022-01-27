module Anon
  class Config
    DEFAULT_SCRIPT_PATH = 'db/anon.rb'.freeze

    def initialize
      @anonymization_attribute = :anonymized_at
      @script = Rails.root.join(DEFAULT_SCRIPT_PATH)
    end

    # @return [Symbol]
    attr_accessor :anonymization_attribute

    # @return [String]
    attr_accessor :script_path
  end
end
