# Buckets provides utility computation methods for computation of quartile statistics
module Quartiles
  class << self
    EFF_BUCKETS = 128

    def quartile_points(buckets)
      spl = spr = 0
      q1 = 0

      p1 = EFF_BUCKETS / 4 - 1
      p2 = EFF_BUCKETS / 2 - 1
      p_end = EFF_BUCKETS - 1

      buckets_cpy = buckets.dup[0..EFF_BUCKETS]

      cut_left = []
      cut_right = []

      l = 0
      r = p_end
      loop do
        ret = partition(buckets_cpy, l, r)
        if ret > p2
          r = ret - 1
          cut_right[spr] = ret
          spr += 1
        elsif ret < p2
          l = ret + 1
          cut_left[spl] = ret
          spl += 1
        else
          q1 = buckets_cpy[p2]
          break
        end
      end

      cut_left[spl] = p2 - 1
      cut_right[spr] = p2 + 1

      q2 = get_q2(buckets_cpy, cut_left, spl, p1)
      q3 = get_q3(buckets_cpy, cut_right, spr, p_end)

      [q1, q2, q3]
    end

    private

    def partition(buffer, left, right)
      return left if left == right

      if left + 1 == right
        if buffer[left] > buffer[right]
          buffer[right], buffer[left] = buffer[left], buffer[right]
        end
        return left
      end

      ret = left

      partition_buffer(buffer, ret, left, right)
    end

    def partition_buffer(buffer, ret, left, right)
      pivot = (left + right) >> 1
      value = buffer[pivot]

      buffer[pivot] = buffer[right]
      buffer[right] = value

      (left..right).each do |i|
        if buffer[i] < value
          buffer[i], buffer[ret] = buffer[ret], buffer[i]
          ret += 1
        end

        buffer[right] = buffer[ret]
        buffer[ret] = value
      end

      ret
    end

    def get_q2(buckets, cut_left, spl, p1)
      i = l = 0
      while i <= spl
        r = cut_left[i]

        if r > p1
          loop do
            ret = partition(buckets, l, r)
            if ret > p1
              r = ret - 1
            elsif ret < p1
              l = ret + 1
            else
              return buckets[p1]
            end
          end
        end

        i += 1
      end
    end

    def get_q3(buckets, cut_right, spr, p_end)
      p3 = EFF_BUCKETS - EFF_BUCKETS / 4 - 1
      q3 = 0

      i = 0
      r = p_end
      while i <= spr
        l = cut_right[i]
        if l < p3
          loop do
            ret = partition(buckets, l, r)
            if ret > p3
              r = ret - 1
            elsif ret < p3
              l = ret + 1
            else
              q3 = buckets[p3]
              break
            end
          end
          break
        elsif l > p3
          r = l
        else
          q3 = buckets[p3]
        end

        i += 1
      end
      q3
    end
  end
end
