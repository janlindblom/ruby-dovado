module Dovado
  class Router
    class Sms
      attr_accessor :unread, :total
      @unread = nil
      @total = nil
      @messages = nil
    
      def initialize(args=nil)
        @messages = Dovado::Router::Sms::Messages.new
      
        unless args.nil?
          @unread = args[:unread] unless args[:unread].nil?
          @total = args[:total] unless args[:total].nil?
        end
      end
    
      def messages
        @messages
      end
    
      def read
        (@total - @unread)
      end
    
      def read= read=nil
        @unread = (@total - read) unless read.nil?
      end
    
    end
  end
end
