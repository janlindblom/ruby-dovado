require 'thread_safe'

module Dovado
  class Router
    class Sms
      class Messages
        include Celluloid
        include Celluloid::Logger
        
        @messages = nil
  
        def initialize(args=nil)
          @messages = ThreadSafe::Cache.new
          debug "Starting up #{self.class.to_s}..."
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
