module Dovado
  class Router
    class Automation
      class Protocol
        class NexaDimmer < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "NEXADIMMER"
            @data_keys = [:nexaselflearninghouse, :nexaselflearningchannel]
          end
        end
      end
    end
  end
end
