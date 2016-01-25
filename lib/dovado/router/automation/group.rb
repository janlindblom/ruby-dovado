module Dovado
  class Router
    class Automation
      class Group
        attr_accessor :id
        attr_accessor :participants

        def initialize(args=nil)
          unless args.nil?
            @id = args[:id] if args.key? :id
          end
          @participants = []
        end
      end
    end
  end
end
