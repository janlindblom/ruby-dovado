
module Dovado
  class Router
    class Info
      class Operator
        include Celluloid
        
        attr_accessor :number, :name, :commands
        
        # Create a new Operator object.
        def initialize(args=nil)
          self.name = "Unknown"
          unless args.nil?
            @number = args[:number] unless args[:number].nil?
          end
        end

      end
    end
  end
end