RSpec.describe Remont::Attribute do
  context 'when processor is explicitly defined' do
    let(:processor) { instance_double('Proc', call: nil) }
    let(:attribute) { described_class.new(:title, using: processor) }

    it 'forwards args to processor' do
      attribute.anonymize(1, 2)

      expect(processor).to have_received(:call).with(1, 2)
    end
  end

  context "when :using option isn't specified" do
    let(:processor) { instance_double('Proc', call: nil) }
    let(:attribute) { described_class.new(:title) { |*args| processor.call(*args) } }

    it 'falls back to the provided block' do
      attribute.anonymize(1, 2)

      expect(processor).to have_received(:call).with(1, 2)
    end
  end
end
