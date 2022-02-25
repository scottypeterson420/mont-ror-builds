# Remont

A DSL for describing and running the row level processing of the records in the databse (eg. anonymization)

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

| Option                       | Default value    | Description                                |
| ---                          | :---:            | ---                                        |
| `process_timestap_attribute` | `:processed_at`  | process status attribute                   |
| `script_path`                | `'db/remont.rb'` | entry point for the schema processing task |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/infinum/remont. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Remont project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/infinum/remont/blob/master/CODE_OF_CONDUCT.md).
