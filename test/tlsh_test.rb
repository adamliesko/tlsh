require './test_helper'

class TlshTest < Minitest::Test
  INPUT_DATA = [11, 4, 0, 12, 4, 0, 8, 8, 4, 12, 0, 12, 8, 4, 4, 4, 8, 12, 0, 4, 8, 8, 12, 8, 4, 7, 20, 7, 4, 4, 4, 8, 4, 0, 4, 4, 8, 8, 0, 0, 0, 4, 4, 4, 8, 8, 12, 12, 8, 0, 4, 12, 0, 8, 4, 0, 4, 4, 10, 4, 4, 8, 12, 12, 8, 3, 0, 8, 8, 8, 4, 4, 16, 0, 0, 12, 12, 23, 4, 4, 4, 4, 15, 4, 12, 4, 12, 4, 16, 8, 12, 0, 4, 0, 20, 8, 8, 0, 4, 0, 4, 4, 8, 8, 24, 0, 0, 4, 16, 4, 8, 0, 4, 0, 4, 8, 0, 0, 14, 4, 4, 12, 12, 12, 8, 4, 4, 0, 8, 4, 4, 0, 20, 8, 4, 19, 4, 0, 4, 4, 4, 4, 0, 15, 4, 4, 0, 8, 8, 0, 4, 8, 0, 16, 0, 0, 12, 4, 4, 4, 11, 0, 8, 0, 12, 12, 8, 8, 4, 8, 3, 26, 8, 8, 4, 0, 0, 4, 8, 15, 12, 4, 4, 20, 7, 4, 4, 4, 0, 4, 8, 15, 4, 4, 0, 0, 4, 11, 4, 4, 8, 4, 4, 0, 0, 4, 8, 0, 0, 16, 16, 4, 8, 27, 4, 8, 11, 7, 0, 16, 8, 12, 0, 0, 8, 12, 8, 0, 4, 4, 0, 4, 4, 4, 0, 4, 12, 4, 8, 4, 16, 0, 4, 4, 0, 15, 0, 4, 8, 4, 8, 0, 12, 0, 12, 0].freeze

  def test_version_number
    refute_nil ::Tlsh::VERSION
  end

  def test_hash_files
    assert_equal('8ed0222fc3080233a02b03b3330fc3a82f8308c2fa0a080b8bae2cca0c3', Tlsh.hash_file('./fixtures/test_file_1').string.to_s)
    assert_equal('b2317c38fac0333c8ff7d3ff31fcf3b7fb3f9a3ef3bf3c880cfc43ebf97f3cc73fbfc', Tlsh.hash_file('./fixtures/test_file_2').string.to_s)
    assert_equal('ea314a879aca13ba2ea6436afa8fa7e7bfafc6bca3389a2aa8eaab789abc6ea3babfa', Tlsh.hash_file('./fixtures/test_file_3').string.to_s)
    assert_equal('5111c1fb371bb32cef13f056b8bcddf23fb25fbfef3ec4247ef345333f7cd5ffc54', Tlsh.hash_file('./fixtures/test_file_4').string.to_s)
    assert_equal('e1d137377e9e43155fe26379d7d9cdaed76ce4342ad79799dcea9b2af55693ce727769', Tlsh.hash_file('./fixtures/test_file_5').string.to_s)
  end

  def test_diff_files
    assert_equal(501, Tlsh.diff_files('./fixtures/test_file_1', './fixtures/test_file_2'))
    assert_equal(0, Tlsh.diff_files('./fixtures/test_file_1', './fixtures/test_file_1'))
    assert_equal(1061, Tlsh.diff_files('./fixtures/test_file_1', './fixtures/test_file_8_lena.png'))
    assert_equal(952, Tlsh.diff_files('./fixtures/test_file_3', './fixtures/test_file_8_lena.png'))
    assert_equal(610, Tlsh.diff_files('./fixtures/test_file_7_lena.jpg', './fixtures/test_file_8_lena.png'))

    assert_raises Errno::ENOENT do
      Tlsh.diff_files('./fixtures/NOT_FOUND', '')
    end
  end

  def test_hash_bytes
    tlsh = Tlsh.hash_bytes(INPUT_DATA)
    p tlsh
    assert_equal('d4d01271eaf3e9b9f0b4cf7b9fc3ee74ae723b32373ee249138b8568ebbbc3ad2a7a', tlsh.string)
    assert_equal([212, 208, 18, 113, 234, 243, 233, 185, 240, 180, 207, 123, 159, 195, 238, 7, 74, 14, 114, 59, 50, 55, 62, 226, 73, 19, 139, 133, 104, 235, 187, 195, 173, 42, 122], tlsh.binary)
  end
end
