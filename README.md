# Versionable
Simple versioning for Rails Active Record with relationship support.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'versionable'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install versionable
```

## Usage

### Setup
Versionable needs `versions` table, which can be generated using these commands:

```ruby
rails g versionable:install
rails db:migrate
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
