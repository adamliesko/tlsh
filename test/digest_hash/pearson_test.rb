require 'test_helper'

class PearsonTest < Minitest::Test
  def test_pearson_hash
    assert_equal(166, DigestHash.pearson_hash(123, [2, 3, 10]))
    assert_equal(124, DigestHash.pearson_hash(0, [0, 0, 0]))
    assert_equal(211, DigestHash.pearson_hash(231, [231, 122, 99]))
  end

  def test_raises_error_missing_keys
    e = assert_raises Tlsh::MalformedInputError do
      DigestHash.pearson_hash(231, [])
    end
    assert_equal('Missing keys for pearson_hash', e.message)

    e = assert_raises Tlsh::MalformedInputError do
      DigestHash.pearson_hash(231, nil)
    end
    assert_equal('Missing keys for pearson_hash', e.message)
  end

  def test_raises_error_missing_salt
    e = assert_raises Tlsh::MalformedInputError do
      DigestHash.pearson_hash(nil, [231, 122, 99])
    end
    assert_equal('Missing salt for pearson_hash', e.message)
  end
end
