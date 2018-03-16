module Dovado
  class Router
    class Automation
      class Protocol
        class Nexa < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "NEXA"
            @data_keys = [:nexahouse, :nexachannel]
          end
        end
      end
    end
  end
end
