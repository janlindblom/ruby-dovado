module Dovado
  class Router
    class Automation
      class Protocol
        class Brateck < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "BRATECK"
            @data_keys = [:brahouse]
          end
        end
      end
    end
  end
end
