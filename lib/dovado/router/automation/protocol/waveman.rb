module Dovado
  class Router
    class Automation
      class Protocol
        class Waveman < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "WAVEMAN"
            @data_keys = [:wavemanhouse, :wavemanchannel]
          end
        end
      end
    end
  end
end
