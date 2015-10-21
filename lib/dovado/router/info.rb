require 'date'
require 'time'
require 'socket'
require 'thread_safe'

module Dovado
  class Router
    # Router information.
    # 
    # @since 1.0.0
    class Info
      include Celluloid

      # Create a new {Info} object.
      # 
      # @param [Hash] args optional hash to initialize with.
      def initialize(args=nil)
        # Defaults
        @data = ThreadSafe::Cache.new

        @last_update = nil
        unless args.nil?
          @data = args
        end
      end

      # Create a new {Info} object from a +String+.
      # 
      # @param [String] data_string router information string from the router.
      def create_from_string(data_string=nil)
        unless Actor[:sms]
          Sms.supervise as: :sms, size: 1
        end
        sms = Actor[:sms]
        data_array = data_string.split("\n")
        data_array.each do |data_entry|
          entry_array = data_entry.split('=')
          if entry_array.length == 2
            key = entry_array[0].downcase
            val = entry_array[1]
            keysym = Utilities.name_to_sym(key)
            case key
            when 'traffic_modem_tx'
              @data[:traffic_modem_tx] = val.strip.to_i
            when 'traffic_modem_rx'
              @data[:traffic_modem_rx] = val.strip.to_i
            when 'time'
              @data[:time] = Time.parse(val)
            when 'date'
              @data[:date] = Date.parse(val)
            when 'sms_unread'
              @data[:sms] = sms if @data[:sms].nil?
              @data[:sms].unread = val.to_i
            when 'sms_total'
              @data[:sms] = sms if @data[:sms].nil?
              @data[:sms].total = val.to_i
            when 'connected_devices'
              val = val.split(',')
              @data[keysym] = val
            else
              @data[keysym] = val
            end
          end
        end
        touch!
      end

      # Determine if this info object is valid.
      #
      # @return [Boolean] true or false.
      def valid?
        return false if @last_update.nil?
        (@last_update + SecureRandom.random_number(9) + 1 <= Time.now.to_i)
      end

      # Fetch an entry from the {Info} object.
      # 
      # @param [Symbol] key The key to fetch.
      def [](key)
        @data[key]
      end

      # Fetch the list of entries in the {Info} object.
      # 
      # @return [Array<Symbol>]
      def keys
        @data.keys
      end

      # Check if the {Info} object has a given key.
      # 
      # @param [Symbol] key the key to check for.
      # @return [Boolean] +true+ or +false+
      def has_key?(key)
        keys.member?(key)
      end

      private

      def touch!
        @last_update = Time.now.to_i
      end

    end
  end
end
