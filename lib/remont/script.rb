module Remont
  class Script
    # @path [String] path
    def initialize(path)
      @path = path
      @schemas = []
    end

    # @return [Object]
    def run!
      instance_eval(File.read(path))

      schemas.each(&:process!)
    end

    # @param [Hash] opts
    # @option [Proc] :model
    # @option [Proc] :scope
    # @param [Proc] block
    # @return [Remont::Schema]
    def schema(...)
      @schemas << Schema.new(...)
    end

    private

    attr_reader :schemas
    attr_reader :path
  end
end
