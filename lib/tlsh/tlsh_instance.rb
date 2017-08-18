module Tlsh
  class TlshInstance
    attr_accessor :checksum, :l_value, :q1_ratio, :q2_ratio, :q_ratio, :body

    def initialize(params = {})
      params.each do |key, value|
        setter = "#{key}="
        send(setter, value) if respond_to?(setter.to_sym, false)
      end
    end

    def diff(other)
      Distance.diff_total(self, other, true)
    end

    # returns the binary representation of the hash
    def binary
      [swap_byte(checksum), swap_byte(l_value), q_ratio] + body
    end

    # returns the string representation of the hash
    def string
      binary.map { |i| i.to_i.to_s(16) }.join('')
    end

    private

    def swap_byte(input)
      out = ((input & 0xF0) >> 4) & 0x0F
      out |= ((input & 0x0F) << 4) & 0xF0
    end
  end
end
