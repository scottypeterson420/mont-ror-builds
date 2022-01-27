module Anon
  class Script
    # @path [String] path
    def initialize(path)
      @path = path
      @schemas = []
    end

    # @return [Object]
    def run!
      instance_eval(File.read(path))

      schemas.each(&:anonymize!)
    end

    # @param [Hash] opts
    # @option [Proc] :model
    # @option [Proc] :scope
    # @param [Proc] block
    # @return [Anon::Schema]
    def schema(...)
      @schemas << Schema.new(...)
    end

    private

    attr_reader :schemas
  end
end
