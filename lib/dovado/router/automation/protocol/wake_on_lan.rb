module Dovado
  class Router
    class Automation
      class Protocol
        class WakeOnLan < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "WOL"
            @data_keys = [:wolmac]
          end
        end
      end
    end
  end
end
