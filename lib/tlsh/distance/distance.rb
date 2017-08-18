# Distance module holds utility functionality for similarity computations of TLSH hashes.
module Distance
  class << self
    # diff_total calculates diff between two Tlsh hashes a and b for hash header and body
    def diff_total(a, b, is_len_diff)
      return -1 unless a.comparable? && b.comparable?
      compute_diff(a, b, is_len_diff)
    end

    private

    def compute_diff(a, b, is_len_diff)
      diff = 0

      if is_len_diff
        len_diff = mod_diff(a.l_value, b.l_value, 256)
        diff += length_diff(len_diff)
      end

      diff += q_diff(a.q1_ratio, b.q1_ratio)
      diff += q_diff(a.q2_ratio, b.q2_ratio)
      diff += 1 if a.checksum != b.checksum
      diff + digest_distance(a.body, b.body)
    end

    def length_diff(len_diff)
      return len_diff if len_diff < 1
      len_diff * 12
    end

    def q_diff(a_ratio, b_ratio)
      diff = mod_diff(a_ratio, b_ratio, 16)
      if diff <= 1
        diff
      else
        (diff - 1) * 12
      end
    end

    # mod_diff calculates steps from byte string x to byte string y in circular queue of size R.
    def mod_diff(x, y, r)
      if y > x
        dl = y - x
        dr = x + r - y
      else
        dl = x - y
        dr = y + r - x
      end
      dl > dr ? dr : dl
    end

    # digest_distance calculates distance between two hash digests
    def digest_distance(x, y)
      diff = 0
      x.zip(y).each do |a, b|
        diff += BIT_PAIRS_DIFF_TABLE[a][b]
      end
      diff
    end
  end
end
