module Dovado
  class Router
    class Automation
      class Protocol
        class Fuhaote < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "FUHAOTE"
            @data_keys = [:fuhaotechannel]
          end
        end
      end
    end
  end
end
