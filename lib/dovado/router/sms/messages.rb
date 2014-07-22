module Dovado
  class Router
    class Sms
      class Messages
        @messages = nil
  
        def initialize(args=nil)
          @messages = {}
        end
  
        def add_message message=nil
          @messages[message.id] = message unless message.nil?
        end
  
        def get_message id=nil
          @messages[id] unless id.nil?
        end

      end
    end
  end
end
