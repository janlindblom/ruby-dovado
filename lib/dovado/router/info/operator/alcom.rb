require "thread_safe"

module Dovado
  class Router
    class Info
      class Operator
        # The Åland operator Ålcom.
        #
        # @since 1.0.5
        class Alcom < Operator

          # Create a new Ålcom Operator object.
          def initialize
            # PLANNING Add known commands and replies from Ålcom.
            super(name: "Ålcom", number: "s12192", commands: {
              balance: 'saldo'.encode('UTF-8')
              })
          end

        end
      end
    end
  end
end
