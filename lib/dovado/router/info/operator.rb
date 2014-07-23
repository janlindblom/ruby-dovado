
module Dovado
  class Router
    class Info
      class Operator
        include Celluloid
        include Celluloid::Logger
        
        attr_accessor :number, :name, :commands
        
        # Create a new Operator object.
        def initialize(args=nil)
          self.name = "Unknown"
          unless args.nil?
            @number = args[:number] unless args[:number].nil?
          end
          debug "Starting up #{self.class.to_s}..."
        end

      end
    end
  end
end