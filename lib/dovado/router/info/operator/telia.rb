require 'thread_safe'

module Dovado
  class Router
    class Info
      class Operator
        # The Swedish operator Telia.
        #
        # @since 1.0.0
        class Telia < Operator
          # Create a new Telia Operator object.
          def initialize
            # PLANNING issue:5 Add known commands and replies from Telia to them.
            super(name: 'Telia', number: 's4466', commands: {
              data_remaining: 'datamängd'.encode('UTF-8')
            })
          end
        end
      end
    end
  end
end
