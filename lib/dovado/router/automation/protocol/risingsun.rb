module Dovado
  class Router
    class Automation
      class Protocol
        class Risingsun < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "RISINGSUN"
            @data_keys = [:risingsunhouse, :risingsunchannel]
          end
        end
      end
    end
  end
end
