module Dovado
  class Router
    class Automation
      class Protocol
        class Sartano < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "SARTANO"
            @data_keys = [:sartanochannel]
          end
        end
      end
    end
  end
end
