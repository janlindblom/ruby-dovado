module Dovado
  class Router
    class Info
      class Operator
        class Telia < Dovado::Router::Info::Operator
        
          # Create a new Telia Operator object.
          def initialize(args=nil)
            self.name = 'Telia'
            self.number = 's4466'
            self.commands = ThreadSafe::Cache.new data_remaining: 'datamängd'.encode('UTF-8')
          end

        end
      end
    end
  end
end
