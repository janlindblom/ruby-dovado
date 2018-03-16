module Dovado
  class Router
    class Automation
      class Protocol
        class NexaSelflearning < Dovado::Router::Automation::Protocol

          def initialize
            @mnemonic = "NEXASELFLEARNING"
            @data_keys = [:nexaselflearninghouse, :nexaselflearningchannel]
          end
        end
      end
    end
  end
end
