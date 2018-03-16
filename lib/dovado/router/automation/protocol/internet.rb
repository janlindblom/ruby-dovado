module Dovado
  class Router
    class Automation
      class Protocol
        class Internet < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "INTERNET"
            @data_keys = []
          end
        end
      end
    end
  end
end
