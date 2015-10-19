module Dovado
  class Router
    class Sms
      include Celluloid

      attr_accessor :unread, :total, :enabled, :ids
      @ids = nil

      def initialize(args=nil)
        Dovado::Router::Sms::Messages.supervise as: :messages
        messages = Actor[:messages]
        @enabled = false
        @ids = ThreadSafe::Array.new
        unless args.nil?
          @unread = args[:unread] unless args[:unread].nil?
          @total = args[:total] unless args[:total].nil?
        end
        client = Actor[:client]
        create_from_string(client.command('sms list'))
      end

      def messages
        Actor[:messages]
      end

      def read
        (@total - @unread)
      end

      def read= read=nil
        @unread = (@total - read) unless read.nil?
      end
      
      def create_from_string data_string=nil
        data_array = data_string.split("\n")
        data_array.each do |data_entry|
          entry_array = data_entry.split(':')
          if entry_array.length == 2
            key = entry_array[0].downcase
            val = entry_array[1]
            if key.downcase.tr(' ', '_') == 'stored_ids'
              idlist = val.split(' ')
              idlist.each do |id|
                @ids << id
              end
            end
          end
        end
        @ids.map! { |id| id.to_i }.sort!
      end
      
      def load_messages
        client = Actor[:client]
        messages = Actor[:messages]
        @ids.each do |id|
          messages.add_message Dovado::Router::Sms::Message.from_string(client.command("sms recvtxt #{id}"))
        end
      end

    end
  end
end
