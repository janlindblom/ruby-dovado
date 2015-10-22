module Dovado
  class Router
    class Traffic
      # Data amount data type. Extends Numeric and can be used as an Integer
      # with the addition of getting the amount as bytes, kilobytes, megabytes
      # or gigabytes.
      # 
      # @since 1.0.2
      class Amount < Numeric

        # The default base of a kilobyte.
        DEFAULT_KILO_BASE = 1024

        # Create a new Amount object.
        # 
        # @param [Numeric] value value of this {Amount}.
        # @param [Integer] base the base of a kilobyte.
        def initialize(value, base=DEFAULT_KILO_BASE)
          raise ArgumentError.new "Argument is not numeric: #{value}" unless value.is_a? Numeric
          @value = value
          @base = base
        end

        # The {Amount} in bytes
        def bytes
          @value * @base
        end

        # The {Amount} in kilobytes
        def kilobytes
          @value
        end

        # The {Amount} in megabytes
        def megabytes
          (kilobytes / @base.to_f).round(2)
        end

        # The {Amount} in gigabytes
        def gigabytes
          (megabytes / @base.to_f).round(2)
        end

      end

      # Create a new {Amount} object.
      # 
      # @param [Numeric] value initial value of the {Amount}.
      # @param [Integer] base the base of a kilobyte.
      def Amount(value, base=DEFAULT_KILO_BASE)
        Amount.new(value, base)
      end
    end
  end
end