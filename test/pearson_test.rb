require './test_helper'

class PearsonTest < Minitest::Test
  def test_pearson_hash
    assert_equal(166, DigestHash.pearson_hash(123, [2, 3, 10]))
    assert_equal(124, DigestHash.pearson_hash(0, [0, 0, 0]))
    assert_equal(211, DigestHash.pearson_hash(231, [231, 122, 99]))
  end
end
