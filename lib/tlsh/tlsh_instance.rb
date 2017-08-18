module Tlsh
  # TlshInstance represents single TLSH instance.
  class TlshInstance
    attr_accessor :checksum, :l_value, :q1_ratio, :q2_ratio, :q_ratio, :body

    ##
    # Creates new instance of TlshInstance from the named arguments.

    def initialize(params = {})
      params.each do |key, value|
        setter = "#{key}="
        send(setter, value) if respond_to?(setter.to_sym, false)
      end
    end

    ##
    # Returns diff (or similarity) against another TlshInstance.
    #
    # The closer to 0, the smaller the diff. Both instances have to be comparable for comparison. If not, -1 is returned.

    def diff(other)
      Distance.diff_total(self, other, true)
    end

    ##
    # Returns the binary representation of the TLSH hash.
    #
    # It's constructed as a concatenation of hash metadata and body,

    def binary
      [swap_byte(checksum), swap_byte(l_value), q_ratio] + body
    end

    ##
    # Returns the string representation of the TLSH hash.
    #
    # It's constructed from the binary representation of the hash, converted to hex

    def string
      binary.map { |i| i.to_i.to_s(16) }.join('')
    end

    private

    def comparable?
      checksum && l_value && q1_ratio && q2_ratio && q_ratio && body
    end

    def swap_byte(input)
      out = ((input & 0xF0) >> 4) & 0x0F
      out | ((input & 0x0F) << 4) & 0xF0
    end
  end
end
