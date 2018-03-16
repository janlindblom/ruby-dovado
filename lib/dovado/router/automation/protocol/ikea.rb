module Dovado
  class Router
    class Automation
      class Protocol
        class Ikea < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "IKEA"
            @data_keys = [:ikeasystem, :ikeadevice]
          end
        end
      end
    end
  end
end
