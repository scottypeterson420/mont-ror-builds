module Remont
  class Schema
    # @return [Array<Remont::Attribute>]
    attr_reader :attributes

    # @return [Nil, String, Symbol]
    attr_reader :process_timestamp_attribute

    # @param [Hash] opts
    # @option [Class] :model
    # @option [Proc] :scope
    # @option [String, Symbol] :process_timestamp_attribute
    # @param [Proc] block
    def initialize(opts = {}, &block)
      @model = opts.fetch(:model)
      @model_scope = opts.fetch(:scope, default_scope)
      @without_processed_scope = default_scope
      @process_timestamp_attribute = opts.fetch(:process_timestamp_attribute, Remont.config.process_timestamp_attribute)
      @before_cb = nil
      @after_cb = nil
      @attributes = []

      instance_eval(&block)
    end

    # @return [Remont::Schema]
    def without_processed
      @without_processed_scope = proc { |scope| scope.where(process_timestamp_attribute => nil) }

      self
    end

    # @param [String, Symbol] attr_name
    # @return [Remont::Schema]
    def with_process_timestamp_attribute(attr_name)
      @process_timestamp_attribute = attr_name

      self
    end

    # @param [Proc] scope
    # @return [Remont::Schema]
    def scope(&scope)
      @model_scope = scope

      self
    end

    # @param [Symbol] name
    # @param [Hash] opts
    # @option [#call] :using
    # @param [Proc] processor
    # @return [Remont::Schema]
    def attribute(...)
      @attributes << Attribute.new(...)

      self
    end

    # @param [Proc] block
    # @return [Remont::Schema]
    def before(&block)
      @before_cb = block

      self
    end

    # @param [Proc] block
    # @return [Remont::Schema]
    def after(&block)
      @after_cb = block

      self
    end

    # @return [Any]
    def process!
      records_for_processing.find_each { |record| processor.process!(record) }
    end

    private

    attr_reader :model
    attr_reader :without_processed_scope
    attr_reader :model_scope
    attr_reader :before_cb
    attr_reader :after_cb

    def processor
      @processor ||= RecordProcessor.new(self, before_cb, after_cb)
    end

    def records_for_processing
      model_scope.call(
        without_processed_scope.call(model.all)
      )
    end

    def default_scope
      proc { |scope| scope }
    end
  end
end
