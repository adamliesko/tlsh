# Buckets provides meat functionality of the TLSH algorithm bucketing
module Buckets
  class << self
    WINDOW_LENGTH = 5
    NUM_BUCKETS = 256
    CODE_SIZE = 32
    SALT = [2, 3, 5, 7, 11, 13].freeze

    def buckets_binary(buckets, q1, q2, q3)
      bin_hash = []

      (0..CODE_SIZE - 1).each do |i|
        h = 0
        (0..3).each do |j|
          k = buckets[4 * i + j]
          h += addition(q1, q2, q3, j, k)
          bin_hash[CODE_SIZE - 1 - i] = h
        end
      end

      bin_hash
    end

    def fill_buckets(input)
      # ensure we have an array (not enumerable)
      input = input.to_a if input.is_a?(Enumerable)

      chunk_slice = input[0..WINDOW_LENGTH - 1].compact
      chunk = chunk_slice[0..5].dup
      chunk.reverse!

      fill_buckets_looping(input, chunk_slice.size, chunk)
    end

    private

    def addition(q1, q2, q3, j, k)
      add = if q3 < k
              3 << j * 2
            elsif q2 < k
              2 << j * 2
            elsif q1 < k
              1 << j * 2
            end
      add ||= 0
      add
    end

    def fill_buckets_looping(input, file_size, chunk)
      buckets = Array.new(NUM_BUCKETS, 0)
      chunk3 = []
      checksum = 0
      current_window = WINDOW_LENGTH - 1

      size = input.size
      loop do
        chunk3[0] = chunk[0]
        chunk3[1] = chunk[1]
        chunk3[2] = checksum
        checksum = DigestHash.pearson_hash(0, chunk3)
        buckets, chunk3, chunk = update_buckets_and_chunk(buckets, chunk3, chunk)

        current_window += 1
        break if current_window >= size

        chunk[0] = input[current_window]
        file_size += 1
      end

      [buckets, checksum, file_size]
    end

    def update_buckets_and_chunk(buckets, chunk3, chunk)
      chunk3[2] = chunk[2]
      buckets[DigestHash.pearson_hash(SALT[0], chunk3)] += 1

      chunk3[2] = chunk[3]
      buckets[DigestHash.pearson_hash(SALT[1], chunk3)] += 1

      chunk3[1] = chunk[2]
      buckets[DigestHash.pearson_hash(SALT[2], chunk3)] += 1

      chunk3[2] = chunk[4]
      buckets[DigestHash.pearson_hash(SALT[3], chunk3)] += 1

      chunk3[1] = chunk[1]
      buckets[DigestHash.pearson_hash(SALT[4], chunk3)] += 1

      chunk3[1] = chunk[3]
      buckets[DigestHash.pearson_hash(SALT[5], chunk3)] += 1

      chunk[1..-1] = chunk[0..3].dup

      [buckets, chunk3, chunk]
    end
  end
end
