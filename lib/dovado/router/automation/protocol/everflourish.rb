module Dovado
  class Router
    class Automation
      class Protocol
        class Everflourish < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "EVERFLOURISH"
            @data_keys = [:everflourishhouse, :everflourishchannel]
          end
        end
      end
    end
  end
end
