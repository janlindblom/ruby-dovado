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

        attr_accessor :sim_id

        # Create a new Amount object.
        #
        # Note: You can set the default base for a kilobyte in the router
        # admin interface to +1000+ or +1024+, you should use the same base here
        # to get the right figures. The base can differ from one operator to
        # another.
        #
        # @param [Numeric] value value of this {Amount}, defaults to +0+.
        # @param [Integer] base the base of a kilobyte.
        def initialize(value = 0, base = DEFAULT_KILO_BASE)
          enforce_numeric_value(value)
          @value = value.to_i
          @base = base
        end

        # The {Amount} in bytes.
        def bytes
          @value * @base
        end

        # Shortcut to {#bytes}.
        def b
          bytes
        end

        # The {Amount} in kilobytes.
        def kilobytes
          @value
        end

        # Shortcut to {#kilobytes}.
        def kb
          kilobytes
        end

        # The {Amount} in megabytes.
        def megabytes
          (kilobytes / @base.to_f).round(2)
        end

        # Shortcut to {#megabytes}.
        def mb
          megabytes
        end

        # The {Amount} in gigabytes.
        def gigabytes
          (megabytes / @base.to_f).round(2)
        end

        # Shortcut to {#gigabytes}.
        def gb
          gigabytes
        end

        private

        def enforce_numeric_value(value)
          error = ArgumentError, "Argument is not numeric: #{value}"
          raise error unless value.is_a? Numeric
        end
      end
    end
  end
end
