module Dovado
  class Router
    class Automation
      class Protocol
        class Arctech < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "ARCTECH"
            @data_keys = [:archouse, :arcchannel]
          end
        end
      end
    end
  end
end
