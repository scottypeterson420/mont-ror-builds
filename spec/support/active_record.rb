require 'sqlite3'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table 'users' do |t|
    t.string :email
    t.string :role
    t.datetime :processed_at
    t.datetime :anonymized_at
  end
end

class User < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  def email # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def role # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def processed_at # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def anonymized_at # rubocop:disable Lint/UselessMethodDefinition
    super
  end
end

RSpec.configure do |config|
  config.after do
    User.delete_all
  end
end
