module Dovado
  class Router
    class Automation
      class Protocol
        class Gembird < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "GEMBIRD"
            @data_keys = [:gembirdoutlet]
          end
        end
      end
    end
  end
end
