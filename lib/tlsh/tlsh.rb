require 'tlsh/version'
require 'tlsh/distance/distance'
require 'tlsh/digest_hash/pearson'

module Tlsh
  LOG1_5 = 0.4054651
  LOG1_3 = 0.26236426
  LOG1_1 = 0.095310180
  CODE_SIZE = 32
  WINDOW_LENGTH = 5
  EFF_BUCKETS = 128
  NUM_BUCKETS = 256

  class << self
    def diff_files(filename, other_filename)
      file_a = File.read(filename)
      file_b = File.read(other_filename)

      tslh_a = tlsh_hash(file_a.bytes)
      tslh_b = tlsh_hash(file_b.bytes)
      tslh_a.diff(tslh_b)
    end

    # hash_file calculates the TLSH for the input file
    def hash_file(filename)
      file = File.read(filename)
      tlsh_hash(file.bytes)
    end

    def hash_bytes(blob)
      tlsh_hash(blob)
    end

    private

    def tlsh_hash(input)
      buckets, checksum, filesize = fill_buckets(input)

      # get the quartiles and their ratio
      q1, q2, q3 = quartile_points(buckets)
      q1_ratio = (q1 * 100 / q3) % 16
      q2_ratio = (q2 * 100 / q3) % 16
      q_ratio = ((q1_ratio & 0xF) << 4) | (q2_ratio & 0xF)

      # get the binary buckets representation
      bin_hash = buckets_binary(buckets, q1, q2, q3)

      TlshInstance.new(checksum: checksum, l_value: l_value(filesize), q1_ratio: q1_ratio, q2_ratio: q2_ratio, q_ratio: q_ratio, body: bin_hash)
    end

    def buckets_binary(buckets, q1, q2, q3)
      bin_hash = []

      (0..CODE_SIZE - 1).each do |i|
        h = 0
        (0..3).each do |j|
          k = buckets[4 * i + j]
          add = if q3 < k
                  3 << j * 2
                elsif q2 < k
                  2 << j * 2
                elsif q1 < k
                  1 << j * 2
                end
          add ||= 0
          h += add

          bin_hash[CODE_SIZE - 1 - i] = h
        end
      end

      bin_hash
    end

    def fill_buckets(input)
      # ensure we have an array (not enumerable)
      input = input.to_a if input.is_a?(Enumerable)

      buckets = Array.new(NUM_BUCKETS, 0)
      salt = [2, 3, 5, 7, 11, 13]
      checksum = 0
      current_window = WINDOW_LENGTH - 1

      size = input.size

      chunk_slice = input[0..current_window].compact
      chunk = chunk_slice[0..5].dup
      chunk.reverse!
      file_size = chunk_slice.size
      chunk_3 = []

      loop do
        chunk_3[0] = chunk[0]
        chunk_3[1] = chunk[1]
        chunk_3[2] = checksum
        checksum = DigestHash.pearson_hash(0, chunk_3)

        chunk_3[2] = chunk[2]
        buckets[DigestHash.pearson_hash(salt[0], chunk_3)] += 1

        chunk_3[2] = chunk[3]
        buckets[DigestHash.pearson_hash(salt[1], chunk_3)] += 1

        chunk_3[1] = chunk[2]
        buckets[DigestHash.pearson_hash(salt[2], chunk_3)] += 1

        chunk_3[2] = chunk[4]
        buckets[DigestHash.pearson_hash(salt[3], chunk_3)] += 1

        chunk_3[1] = chunk[1]
        buckets[DigestHash.pearson_hash(salt[4], chunk_3)] += 1

        chunk_3[1] = chunk[3]
        buckets[DigestHash.pearson_hash(salt[5], chunk_3)] += 1

        chunk[1..-1] = chunk[0..3].dup
        current_window += 1

        break if current_window >= size

        chunk[0] = input[current_window]

        file_size += 1
      end
      [buckets, checksum, file_size]
    end

    def quartile_points(buckets)
      spl = spr = 0
      q1 = q2 = q3 = 0

      p1 = EFF_BUCKETS / 4 - 1
      p2 = EFF_BUCKETS / 2 - 1
      p3 = EFF_BUCKETS - EFF_BUCKETS / 4 - 1
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
          q2 = buckets_cpy[p2]
          break
        end
      end

      cut_left[spl] = p2 - 1
      cut_right[spr] = p2 + 1

      i = l = 0
      while i <= spl
        r = cut_left[i]

        if r > p1
          loop do
            ret = partition(buckets_cpy, l, r)
            if ret > p1
              r = ret - 1
            elsif ret < p1
              l = ret + 1
            else
              q1 = buckets_cpy[p1]
              break
            end
          end
        end

        i += 1
      end

      i = 0
      r = p_end
      while i <= spr
        l = cut_right[i]
        if l < p3
          loop do
            ret = partition(buckets_cpy, l, r)
            if ret > p3
              r = ret - 1
            elsif ret < p3
              l = ret + 1
            else
              q3 = buckets_cpy[p3]
              break
            end
          end
          break
        elsif l > p3
          r = l
        else
          q3 = buckets_cpy[p3]
        end

        i += 1

      end

      [q1, q2, q3]
    end

    def partition(buffer, left, right)
      return left if left == right

      if left + 1 == right
        if buffer[left] > buffer[right]
          buffer[right], buffer[left] = buffer[left], buffer[right]
        end
        return left
      end

      ret = left
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

    def l_value(length)
      l = if length <= 656
            Float(Math.log(length) / LOG1_5).floor.to_i
          elsif length <= 3199
            Float(Math.log(length) / LOG1_3 - 8.72777).floor.to_i
          else
            Float(Math.log(length) / LOG1_1 - 62.5472).floor.to_i
          end
      l & 255
    end
  end
end
