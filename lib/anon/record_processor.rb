module Anon
  class RecordProcessor
    NOOP = proc {}

    # @param [Array<Anon::Attribute>] attributes
    # @param [Proc] before
    # @param [Proc] after
    def initialize(attributes, before, after)
      @attributes = attributes
      @before = before || NOOP
      @after = after || NOOP
    end

    # @param [ActiveRecord::Base] record
    def anonymize!(record)
      before.call(record)
      record.update_columns(
        anonymized_attributes(record)
      )
      after.call(record)

      record
    end

    private

    attr_reader :attributes
    attr_reader :before
    attr_reader :after

    def anonymized_attributes(record)
      attributes
        .select { |attribute| record.send(attribute.name).present? }
        .reduce(default_anonymization_attributes) do |memo, attribute|
          memo.merge(attribute.name => attribute.anonymize(record.send(attribute.name), record))
        end
    end

    def default_anonymization_attributes
      {
        Anon.config.anonymization_attribute => Time.zone.now
      }
    end
  end
end
