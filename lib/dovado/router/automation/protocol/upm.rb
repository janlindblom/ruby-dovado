module Dovado
  class Router
    class Automation
      class Protocol
        class UPM < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "UPM"
            @data_keys = [:upmhouse, :upmchannel]
          end
        end
      end
    end
  end
end
