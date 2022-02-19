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
    def schema(*_arts)
      @schemas << Schema.new(*args)
    end

    private

    attr_reader :schemas
    attr_reader :path
  end
end
