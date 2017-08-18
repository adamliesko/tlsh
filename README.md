[![Build Status](https://travis-ci.org/adamliesko/tlsh.svg?branch=master)](https://travis-ci.org/adamliesko/tlsh)
[![Coverage Status](https://coveralls.io/repos/github/adamliesko/tlsh/badge.svg?branch=master)](https://coveralls.io/github/adamliesko/tlsh?branch=master)

# TLSH - Trend Micro Locality Sensitive Hash
  
TLSH is a fuzzy matching library. Given a byte stream with a minimum length of 256 bytes , TLSH generates a hash value which can be used for similarity comparisons. Similar objects will have similar hash values which allows for the detection of similar objects by comparing their hash values. Note that the byte stream should have a sufficient amount of complexity. For example, a byte stream of identical bytes will not generate a hash value.

The computed hash is 35 bytes long (output as 70 hexidecimal charactes). The first 3 bytes are used to capture the information about the file as a whole (length, ...), while the last 32 bytes are used to capture information about incremental parts of the file.

## Installation

Add this line to your application's Gemfile and execute bundler:

```ruby
gem 'tlsh' && bundle
```

Or install it yourself as:

    $ gem install tlsh

## Usage

Computing a diff between two files
```ruby
> Tlsh.diff_files('./../fixtures/test_file_1', './../fixtures/test_file_2')
 => 501
```

Getting a hash of a file
```ruby
> tlsh = Tlsh.hash_file('./../fixtures/test_file_1', './../fixtures/test_file_2')
 => 501
> tlsh.string.to_s
 => "b2317c38fac0333c8ff7d3ff31fcf3b7fb3f9a3ef3bf3c880cfc43ebf97f3cc73fbfc"
```

Getting a hash of bytes
```ruby
> Tlsh.hash_bytes([11,4,...2])
 => #<Tlsh::TlshInstance:0x007fddf7cf7f60 @checksum=77, @l_value=13, @q1_ratio=1, @q2_ratio=2, @q_ratio=18, @code=[113, 234, 243, 233, 185, 240, 180, 207, 123, 159, 195, 238, 7, 74, 14, 114, 59, 50, 55, 62, 226, 73, 19, 139, 133, 104, 235, 187, 195, 173, 42, 122]>
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[adamliesko]/tlsh. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tlsh project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[adamliesko]/tlsh/blob/master/CODE_OF_CONDUCT.md).
