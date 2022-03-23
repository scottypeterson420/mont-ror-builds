RSpec.describe Remont::RecordProcessor do
  subject(:processor) do
    described_class.new(schema, callback, callback)
  end

  let(:schema) do
    Remont::Schema.new(model: User) do
      with_process_timestamp_attribute :anonymized_at
      attribute(:email) { 'email' }
      attribute(:role) { 'role' }
    end
  end
  let(:callback) { instance_double('Proc', call: nil) }
  let(:record) do
    instance_double('User', email: 'bob@example.com', role: 'admin', update_columns: nil)
  end

  it 'updates record with processed attributes' do
    now = Time.now.getlocal
    Timecop.freeze(now) do
      processor.process!(record)
    end

    expect(record).to have_received(:update_columns).with(
      email: 'email', role: 'role', anonymized_at: now
    )
  end

  it 'invokes callback before and after the processing' do
    processor.process!(record)

    expect(callback).to have_received(:call).twice.with(record)
  end
end
