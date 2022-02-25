RSpec.describe Remont::Config do
  context 'without custom options' do
    let(:config) { described_class.new }

    it 'initializes default anonymization attribute' do
      expect(config.anonymization_attribute).to eq(:anonymized_at)
    end

    it 'initializes default script path' do
      expect(config.script_path).to eq(Remont::Config::DEFAULT_SCRIPT_PATH)
    end
  end
end
