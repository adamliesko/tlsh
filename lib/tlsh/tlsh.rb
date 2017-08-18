require 'tlsh/version'
require 'tlsh/distance/distance'
require 'tlsh/digest_hash/pearson'

# Tlsh module implement interface for TLSH (Trend Micro Locality Sensitive Hash) computation.
# TLSH is usable for diff and similarity computations of binary data, because of the locality sensitivity.
module Tlsh
  LOG1_5 = 0.4054651
  LOG1_3 = 0.26236426
  LOG1_1 = 0.095310180

  class << self
    ##
    # Computes TLSH based diff between two files.
    #
    # The closer to 0, the smaller the diff. If files are not found, error is raised.

    def diff_files(filename, other_filename)
      file_a = File.read(filename)
      file_b = File.read(other_filename)

      tslh_a = tlsh_hash(file_a.bytes)
      tslh_b = tlsh_hash(file_b.bytes)
      tslh_a.diff(tslh_b)
    end

    ##
    # Computes TLSH based diff between two files.
    #
    # The closer to 0, the smaller the diff. If files are not found, error is raised.

    def hash_file(filename)
      file = File.read(filename)
      tlsh_hash(file.bytes)
    end

    ##
    # Computes TLSH of an bytes input.

    def hash_bytes(blob)
      tlsh_hash(blob)
    end

    private

    def tlsh_hash(input)
      raise Tlsh::InputTooSmallError if input.size < 256
      buckets, checksum, filesize = Buckets.fill_buckets(input)

      # get the quartiles and their ratio
      q1, q2, q3 = Quartiles.quartile_points(buckets)
      q1_ratio = (q1 * 100 / q3) % 16
      q2_ratio = (q2 * 100 / q3) % 16
      q_ratio = ((q1_ratio & 0xF) << 4) | (q2_ratio & 0xF)

      # get the binary buckets representation
      bin_hash = Buckets.buckets_binary(buckets, q1, q2, q3)

      TlshInstance.new(checksum: checksum, l_value: l_value(filesize), q1_ratio: q1_ratio, q2_ratio: q2_ratio, q_ratio: q_ratio, body: bin_hash)
    end

    def l_value(length)
      l = if length <= 656
            l_value_small(length)

          elsif length <= 3199
            l_value_medium(length)

          else
            l_value_large(length)
          end
      l & 255
    end

    def l_value_small(length)
      Float(Math.log(length) / LOG1_5).floor.to_i
    end

    def l_value_medium(length)
      Float(Math.log(length) / LOG1_3 - 8.72777).floor.to_i
    end

    def l_value_large(length)
      Float(Math.log(length) / LOG1_1 - 62.5472).floor.to_i
    end
  end
end
