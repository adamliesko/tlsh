# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tlsh/version'

Gem::Specification.new do |spec|
  spec.name          = 'tlsh'
  spec.version       = Tlsh::VERSION
  spec.authors       = ['adamliesko']
  spec.email         = ['adamliesko@gmail.com']

  spec.summary       = 'A fuzzy matching library which creates hashes that can be used for similarity comparisons.'
  spec.description = <<DESC
tlsh is a fuzzy matching library, which hashes can be used for similarity comparison.
Given a byte stream with a minimum length of 256 bytes, TLSH generates a hash value
which can be used for similarity comparisons. Similar objects will have similar hash
values which allow for the detection of similar objects by comparing their hash values.

The computed hash is 35 bytes long (output as 70 hexadecimal characters).
The first 3 bytes are used to capture the information about the file as a whole (length, ...),
while the last 32 bytes are used to capture information about incremental parts of the file.
DESC

  spec.homepage      = 'https://github.com/adamliesko/tlsh'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'coveralls', '~> 0'
  spec.add_development_dependency 'simplecov', '~> 0'
end
