require 'thread_safe'

module Dovado
  class Router
    class Sms
      # Text messages.
      #
      # @since 1.0.0
      class Messages
        include Celluloid

        # Create a new {Messages} object.
        def initialize
          @messages = ThreadSafe::Cache.new
        end

        # Add a message to the local cache.
        # @param [Message] message
        def add_message(message)
          @messages[message.id] = message unless message.nil?
        end

        # Fetch a {Message} from the cache.
        #
        # @param [String,Integer,Symbol] id Id of the message.
        # @return [Message] message object.
        # @see {Message}
        def get_message(id)
          @messages[id] unless id.nil?
        end

        def [](id)
          get_message(id)
        end

        def ids
          @messages.keys
        end
      end
    end
  end
end
