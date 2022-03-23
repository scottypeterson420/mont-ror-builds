RSpec.describe Remont::Config do
  context 'without custom options' do
    let(:config) { described_class.new }

    it 'initializes default process timestamp attribute' do
      expect(config.process_timestamp_attribute).to eq(:processed_at)
    end
  end
end
