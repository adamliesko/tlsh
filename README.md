# TLSH - Trend Micro Locality Sensitive Hash
  
TLSH is a fuzzy matching library. Given a byte stream with a minimum length of 256 bytes , TLSH generates a hash value which can be used for similarity comparisons. Similar objects will have similar hash values which allows for the detection of similar objects by comparing their hash values. Note that the byte stream should have a sufficient amount of complexity. For example, a byte stream of identical bytes will not generate a hash value.

The computed hash is 35 bytes long (output as 70 hexidecimal charactes). The first 3 bytes are used to capture the information about the file as a whole (length, ...), while the last 32 bytes are used to capture information about incremental parts of the file.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tlsh'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tlsh

## Usage

Computing a diff between two files

Getting a hash of a file

Getting a hash of 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tlsh. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tlsh project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/tlsh/blob/master/CODE_OF_CONDUCT.md).
