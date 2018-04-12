module Dovado
  class Router
    # Text messages.
    #
    # @since 1.0.0
    class Sms
      # PLANNING issue:8 Enable creating and sending text messages.
      include Celluloid

      # Unread messages.
      # @return [Integer] number of unread
      attr_accessor :unread
      # Total number of messages.
      # @return [Integer] total number of messages
      attr_accessor :total
      # Is the SMS handler enabled?
      # @return [Boolean] +true+ or +false+
      attr_accessor :enabled
      # Message Id's.
      # @return [Array] list of message Id's
      attr_accessor :ids

      # Create a new {Sms} object.
      #
      # @param [Hash] args optional arguments.
      # @option args [Integer] :unread number of unread messages
      # @option args [Integer] :total total number of messages
      def initialize(args = nil)
        Messages.supervise as: :messages, size: 1
        @enabled = false
        @ids = ThreadSafe::Array.new
        unless args.nil?
          @unread = args[:unread] unless args[:unread].nil?
          @total = args[:total] unless args[:total].nil?
        end
        client = Actor[:client]
        create_from_string(client.command('sms list'))
      end

      # Text messages.
      #
      # @return [Sms::Messages]
      def messages
        Actor[:messages]
      end

      # Number of read messages.
      #
      # @return [Integer] the number of read messages.
      def read
        (@total - @unread)
      end

      # Assign number of read messages.
      #
      # @param [Integer] read Number of read messages.
      def read=(read = nil)
        @unread = (@total - read) unless read.nil?
      end

      # Create a new {Sms} object from a +String+ with data fetched from the
      # router.
      #
      # @param [String] data_string String with text message data from the
      # router.
      # @api private
      def create_from_string(data_string = nil)
        data_array = data_string.split("\n")
        data_array.each do |data_entry|
          entry_array = data_entry.split(':')
          process_entry_array!(entry_array) if entry_array.length == 2
        end
        @ids.reject!(&:nil?)
        @ids.map!(&:to_i)
        @ids.sort!
      end

      # Load text messages.
      #
      # This is not done automatically since it's a rather time consuming
      #   operation.
      def load_messages!
        client = setup_client

        @ids.each do |id|
          command = client.command("sms recvtxt #{id}")
          messages.add_message Message.from_string(command)
        end
        true
      rescue StandardError
        false
      end

      def self.setup_supervision!
        supervise as: :sms, size: 1 unless Actor[:sms]
      end

      private

      def process_entry_array!(entry_array)
        key = entry_array[0].downcase.tr(' ', '_')
        val = entry_array[1]
        val.split(' ').each { |id|
          @ids << id unless id.nil?
          } if key == 'stored_ids'
      end

      def setup_client
        client = Actor[:client]
        client.connect unless client.connected?
        client.authenticate unless client.authenticated?
        client
      end
    end
  end
end
