require 'test_helper'

class TlshInstance < Minitest::Test
  def setup
    @tlsh = Tlsh::TlshInstance.new(checksum: 232, l_value: 13, q1_ratio: 2, q2_ratio: 2, q_ratio: 34, body: [2, 252, 48, 128, 35, 3, 160, 2, 176, 59, 51, 48, 15, 195, 10, 130, 248, 48, 8, 194, 250, 0, 10, 0, 128, 184, 186, 14, 2, 204, 160, 195])
  end

  def test_string
    assert_equal('8ed0222fc3080233a02b03b3330fc3a82f8308c2fa0a080b8bae2cca0c3', @tlsh.string)

    # note the change at the beginning of the hash
    @tlsh.checksum = 2
    assert_equal('20d0222fc3080233a02b03b3330fc3a82f8308c2fa0a080b8bae2cca0c3', @tlsh.string)

    # change the end of the hash
    @tlsh.body[-1] = 44
    assert_equal('20d0222fc3080233a02b03b3330fc3a82f8308c2fa0a080b8bae2cca02c', @tlsh.string)

    # change the beginning of the hash
    @tlsh.l_value = 94
    assert_equal('20e5222fc3080233a02b03b3330fc3a82f8308c2fa0a080b8bae2cca02c', @tlsh.string)
  end

  def test_binary
    assert_equal([142, 208, 34, 2, 252, 48, 128, 35, 3, 160, 2, 176, 59, 51, 48, 15, 195, 10, 130, 248, 48, 8, 194, 250, 0, 10, 0, 128, 184, 186, 14, 2, 204, 160, 195], @tlsh.binary)
  end

  def test_diff
    other = Tlsh::TlshInstance.new(checksum: 23, l_value: 2, q1_ratio: 2, q2_ratio: 2, q_ratio: 34, body: [1, 251, 48, 128, 35, 3, 160, 2, 176, 59, 51, 48, 15, 195, 10, 130, 248, 48, 8, 194, 250, 0, 10, 0, 128, 184, 186, 14, 2, 204, 160, 195])
    assert_equal(141, @tlsh.diff(other))
  end
end
