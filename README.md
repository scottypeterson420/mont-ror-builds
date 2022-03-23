# Remont

A DSL for describing and running the row-level processing of the records in the database (eg. anonymization)

## Installation
Add this line to your application's Gemfile:
```ruby
gem 'remont'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install remont

## Application configuration
Add `config/initializers/remont.rb`
```ruby
Remont.setup do |config|
  config.process_timestamp_attribute = :processed_at
  config.script_path = 'db/remont.rb'
end
```

| Option                        | Default value    | Description                                |
| ---                           | :---:            | ---                                        |
| `process_timestamp_attribute` | `nil`            | processing status attribute identifier     |
| `script_path`                 | `'db/remont.rb'` | entry point for the schema processing task |

On successful record processing, `process_timestamp_attribute` on the record will be set to the current processing time (`Time.now.getlocal`).

## Usage
In the following example, the intention is to simulate anonymization of the `users` and `orders` table.
- configure the global options
```ruby
# config/initializers/remont.rb
Remont.setup do |config|
  config.process_timestamp_attribute = :anonyzmied_at
  config.script_path = 'db/anonymize.rb'
end
```
- define processing script
```ruby
# db/anonymize.rb
schema model: User  do
  attribute(:email) { 'user@example.com' }
end

schema model: Order do
  attribute(:billing_address) { '23 Wall Street, NY' }
end
```
- and run `bundle exec rake remont`

Running the rake task would result in updating `email` (and `anonymized_at`) column for each row in the `users` table, and `billing_address` column for each row in the `orders` table.

### Schema
Defines database table hosting the rows to be processed. The initial dataset is defined through the `model` option in the `schema` method. `model` value must be a subclass of the `ActiveRecord::Base`.
```ruby
schema model: Order do
end
```
### Controlling the scope
Scope of the data that will be processed is controlled
- with `scope` option in the `schema` method
- by declaring custom `scope` within the `schema` block
```ruby
# skip admin records
schema model: User, scope: { |scope| scope.where.not(role: :admin) } do
end

schema model: Order do
  # process only active records
  scope { |scope| scope.where(status: :active) }
end
```
### Recording the processing end time
Library supports an option to store the processing end time of a record. Enable the behavior by configuring a processing status attribute identifier for the schema. Configure the attribute identifier
- globally (`Remont::Config#process_timestamp_attribute`, for all schemas)
- or individually per schema (in the schema DSL, overrides the global setting)
```ruby
schema model: User, process_timestamp_attribute: :anonymized_at do
end

schema model: Order do
  with_process_timestamp_attribute :anonymized_at
end
```

Set process status attribute to `nil` to disable the behavior.
### Skipping the processed records
In some cases, it's desirable to skip already processed records. You can enable this behavior by declaring `without_processed` within the `schema` block. When declared, the processing dataset query will be extended with a condition that excludes already processed records.
```ruby
schema model: User do
  without_processed
  # ...
end
```
Configure processing status attribute before declaring the `without_processed`. An error will be raised otherwise.
### Callbacks
Custom pre-processing or post-processing behavior can be declared using `before` and `after` callbacks.
```ruby
schema model: User do
  before { |record| Rails.logger.info("Started processing: #{record.id}") }
  after { |record| Rails.logger.info("Finished processing: #{record.id}") }
end
```
### Attributes
Attributes are processed using processors (an object which responds to the `call` method). The processor can be defined either as a block or with the `:using` option passed to the `attribute` method.
```ruby
require 'securerandom'

class CachedNick
  def initialize
    @cache = Hash.new { |hash, nick| hash[nick] = SecureRandom.uuid }
  end

  def call(nick, _record)
    @cache[nick]
  end
end

schema model: User do
  attribute(:email) { |email, record| "#{record.id}-#{email}" }
  attribute(:nickname, using: CachedNick.new)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/infinum/remont. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Remont project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/infinum/remont/blob/master/CODE_OF_CONDUCT.md).
