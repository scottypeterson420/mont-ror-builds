RSpec.describe Remont::Script do
  include TestHelpers::Script

  it 'processes the records in the defined schema' do
    bob = User.create(email: 'bob@example.com', role: 'admin')

    process(<<~SCRIPT)
      schema model: User do
        attribute(:email) { '--' }
      end
    SCRIPT

    expect(bob.reload.email).to eq('--')
  end
end
