module Anon
  class Schema
    DEFAULT_SCOPE = proc { |scope| scope }
    WITHOUT_ANONYMIZED = proc { |scope| scope.where.not(Anon.config.anonymization_attribute => nil) }

    # @param [ActiveRecord::Base] ar_class
    # @param [Hash] opts
    # @option [Class] :model
    # @option [Proc] :scope
    # @param [Proc] block
    def initialize(opts = {}, &block)
      @model = opts.fetch(:model)
      @model_scope = opts.fetch(:scope, DEFAULT_SCOPE)
      @without_anonymized_scope = DEFAULT_SCOPE
      @before_cb = nil
      @after_cb = nil
      @attributes = []

      instance_eval(&block)
    end

    # @return [Anon::Schema]
    def without_anonymized
      @without_anonymized_scope = WITHOUT_ANONYMIZED

      self
    end

    # @param [Proc] :scope
    # @return [Anon::Schema]
    def scope(&scope)
      @model_scope = scope

      self
    end

    # @param [Symbol] name
    # @param [Proc] block
    # @return [Anon::Schema]
    def attribute(name, &block)
      @attributes << Attribute.new(name, &block)

      self
    end

    # @param [Proc] block
    # @return [Anon::Schema]
    def before(&block)
      @before_cb = block

      self
    end

    # @param [Proc] block
    # @return [Anon::Schema]
    def after(&block)
      @after_cb = block

      self
    end

    # @return [Any]
    def anonymize!
      records_for_anonymization.find_each { |record| processor.anonymize!(record) }
    end

    private

    attr_reader :model, :without_anonymized_scope, :model_scope, :attributes, :before_cb, :after_cb

    def processor
      @processor ||= RecordProcessor.new(attributes, before_cb, after_cb)
    end

    def records_for_anonymization
      model_scope.call(
        without_anonymized_scope.call(model.all)
      )
    end

    def anonymize_record!(record)
      processor.anonymize!(record)
    end
  end
end
