module Dovado
  class Router
    class Info
      # Signal Strength object
      # 
      # @since 1.0.3
      class Signal

        # Strength as a percentage
        # 
        # @return [Integer] an integer from +0+ to +100+
        attr_reader :strength

        # Signal noise level in dBm
        # 
        # @return [Integer] noise level (dBm)
        attr_reader :noise

        # Network type
        # 
        # One of:
        # - 2G
        # - 3G
        # - 4G
        # 
        # @return [String] current network type
        attr_reader :network

        def initialize(args)
          @strength = args[:strength].to_i
          @noise = args[:noise].to_i
          @network = args[:network]
        end

      end
    end
  end
end