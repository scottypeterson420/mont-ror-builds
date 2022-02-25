RSpec.describe Remont::Schema do
  it 'processes each matching record' do # rubocop:disable RSpec/ExampleLength
    bob = User.create(email: 'bob@example.com', role: 'admin', processed_at: nil)
    schema = described_class.new(model: User) do
      attribute(:email) { 'email' }
    end

    Timecop.freeze do
      expect do
        schema.process!
        bob.reload
      end.to change(bob, :email).to('email')
                                .and change(bob, :processed_at).to(Time.now.getlocal)
    end
  end

  context 'without scope applied' do
    let(:schema) do
      described_class.new(model: User) do
        attribute(:email) { 'email' }
      end
    end

    it 'processes all records' do
      bob = User.create(email: 'bob@example.com', role: 'customer', processed_at: nil)
      alice = User.create(email: 'alice@example.com', role: 'admin', processed_at: nil)

      schema.process!

      expect(bob.reload.processed_at).not_to be_nil
      expect(alice.reload.processed_at).not_to be_nil
    end
  end

  context 'with the scope specified' do
    let(:schema) do
      described_class.new(
        model: User,
        scope: proc { |relation| relation.where(role: 'customer') }
      ) do
        attribute(:email) { 'email' }
      end
    end

    it 'processes only matching records' do
      bob = User.create(email: 'bob@example.com', role: 'customer', processed_at: nil)
      alice = User.create(email: 'alice@example.com', role: 'admin', processed_at: nil)

      schema.process!

      expect(bob.reload.processed_at).not_to be_nil
      expect(alice.reload.processed_at).to be_nil
    end
  end

  context 'when skip process scope is enabled' do
    let(:schema) do
      described_class.new(model: User) do
        without_processed
        attribute(:email) { 'email' }
      end
    end

    it 'processes only non-processed records' do
      processed_at = Time.now.getlocal
      bob = User.create(email: 'bob@example.com', role: 'admin', processed_at: processed_at)
      alice = User.create(email: 'alice@example.com', role: 'admin', processed_at: nil)

      schema.process!

      expect(bob.reload.processed_at).to eq(processed_at)
      expect(alice.reload.processed_at).not_to be_nil
    end
  end

  context 'with before callback specified' do
    let(:callback) { instance_double('Proc', call: nil) }

    let(:schema) do
      cb = callback

      described_class.new(model: User) do
        without_processed
        attribute(:email) { 'email' }
        before { |*args| cb.call(*args) }
      end
    end

    it 'invokes callback for each matching record' do
      bob = User.create(email: 'bob@example.com')
      alice = User.create(email: 'alice@example.com')

      schema.process!

      expect(callback).to have_received(:call).with(bob)
      expect(callback).to have_received(:call).with(alice)
    end
  end

  context 'with after callback specified' do
    let(:callback) { instance_double('Proc', call: nil) }

    let(:schema) do
      cb = callback

      described_class.new(model: User) do
        without_processed
        attribute(:email) { 'email' }
        after { |*args| cb.call(*args) }
      end
    end

    it 'invokes callback for each matching record' do
      bob = User.create(email: 'bob@example.com')
      alice = User.create(email: 'alice@example.com')

      schema.process!

      expect(callback).to have_received(:call).with(bob)
      expect(callback).to have_received(:call).with(alice)
    end
  end
end
