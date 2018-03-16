module Dovado
  class Router
    class Automation
      class Protocol
        class Proove < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "PROOVE"
            @data_keys = [:proovehouse, :proovechannel]
          end
        end
      end
    end
  end
end
