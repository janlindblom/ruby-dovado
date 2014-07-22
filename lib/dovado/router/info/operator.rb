
module Dovado
  class Router
    class Info
      class Operator
        attr_accessor :number, :name
        @number = nil
        
        def initialize(args=nil)
          unless args.nil?
            @number = args[:number] unless args[:number].nil?
          end
        end
        
      end
    end
  end
end