RSpec.describe Remont::Script do
  include TestHelpers::Script

  it 'processes the records in the defined schema' do
    bob = User.create(email: 'bob@example.com', role: 'admin', processed_at: nil)

    process(<<~SCRIPT)
      schema model: User do
        attribute(:email) { '--' }
      end
    SCRIPT

    bob.reload
    expect(bob.email).to eq('--')
    expect(bob.processed_at).not_to be_nil
  end
end
