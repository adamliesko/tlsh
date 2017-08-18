require './test_helper'

class DistanceTest < Minitest::Test
  def test_diff_total
    a = Tlsh::TlshInstance.new
    b = Tlsh::TlshInstance.new
    assert_equal(nil, Distance.diff_total(a, b, false))

    a = Tlsh::TlshInstance.new(checksum: 232, l_value: 13, q1_ratio: 2, q2_ratio: 2, q_ratio: 34, code: [2, 252, 48, 128, 35, 3, 160, 2, 176, 59, 51, 48, 15, 195, 10, 130, 248, 48, 8, 194, 250, 0, 10, 0, 128, 184, 186, 14, 2, 204, 160, 195])
    b = Tlsh::TlshInstance.new(checksum: 232, l_value: 13, q1_ratio: 2, q2_ratio: 2, q_ratio: 34, code: [2, 252, 48, 128, 35, 3, 160, 2, 176, 59, 51, 48, 15, 195, 10, 130, 248, 48, 8, 194, 250, 0, 10, 0, 128, 184, 186, 14, 2, 204, 160, 195])
    assert_equal(0, Distance.diff_total(a, b, true))

    a = Tlsh::TlshInstance.new(checksum: 232, l_value: 13, q1_ratio: 2, q2_ratio: 2, q_ratio: 34, code: [2, 252, 48, 128, 35, 3, 160, 2, 176, 59, 51, 48, 15, 195, 10, 130, 248, 48, 8, 194, 250, 0, 10, 0, 128, 184, 186, 14, 2, 204, 160, 195])
    b = Tlsh::TlshInstance.new(checksum: 212, l_value: 5, q1_ratio: 2, q2_ratio: 2, q_ratio: 15, code: [2, 252, 48, 128, 35, 3, 160, 2, 175, 59, 51, 48, 15, 195, 10, 130, 248, 48, 8, 194, 2, 0, 10, 0, 128, 184, 186, 14, 2, 204, 160, 195])
    assert_equal(124, Distance.diff_total(a, b, true))
  end
end
