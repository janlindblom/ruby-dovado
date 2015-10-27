require 'date'
require 'time'
require 'socket'
require 'ipaddr'
require 'thread_safe'

module Dovado
  class Router
    # Router information.
    # 
    # @since 1.0.0
    class Info
      include Celluloid

      # Get the product name
      # 
      # @return [String] product name
      # @since 1.0.3
      attr_reader :product_name

      # Get the current signal strength information
      # 
      # @return [Info::Signal] current signal strength information
      # @since 1.0.3
      # @see {Info::Signal}
      attr_reader :signal_strength

      # Get the number of kilobytes sent to the internet since last traffic
      # counter reset.
      # 
      # @return [Integer] number of kilobytes sent to the internet
      # @since 1.0.3
      attr_reader :traffic_modem_tx

      # Get the number of kilobytes read from the internet since last traffic
      # counter reset.
      # 
      # @return [Integer] number of kilobytes read from the internet
      # @since 1.0.3
      attr_reader :traffic_modem_rx

      # Get the currently active connection
      # 
      # @return [String] the port currently active as internet connection
      # @since 1.0.3
      attr_reader :connection

      # Get the current state of the connected modem
      # 
      # @return [String] current state of the connected modem
      # @since 1.0.3
      attr_reader :modem_status

      # Get the external IP address of the router
      # 
      # @return [IPAddr] external IP address
      # @since 1.0.3
      attr_reader :external_ip

      # Get the current date on the router
      # 
      # @return [Date] current date
      # @since 1.0.3
      attr_reader :date

      # Get the current time on the router
      # 
      # @return [Time] current time
      # @since 1.0.3
      attr_reader :time

      # Get the GPS type
      # 
      # @return [String] the type of GPS
      # @since 1.0.3
      attr_reader :gps_type

      # Get the GPS latitude
      # 
      # @return [Float] GPS latitude
      # @since 1.0.3
      attr_reader :gps_lat

      # Get the GPS longitude
      # 
      # @return [Float] GPS longitude
      # @since 1.0.3
      attr_reader :gps_long

      # Get the sunrise at the current location
      # 
      # @return [Time] sunrise at the current location
      # @since 1.0.3
      attr_reader :sunrise

      # Get sunset at the current location
      # 
      # @return [Time] sunset at the current location
      # @since 1.0.3
      attr_reader :sunset

      # Get the sms object
      # 
      # @return [Sms] the sms object
      # @since 1.0.3
      attr_reader :sms

      # Get connected devices
      # 
      # @return [Array<String>] an array with connected devices
      # @since 1.0.3
      attr_reader :connected_devices

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
            when 'traffic_modem_tx', 'traffic_modem_rx'
              @data[keysym] = val.strip.to_i
            when 'time', 'sunset', 'sunrise'
              @data[keysym] = Time.parse(val.strip)
            when 'date'
              @data[:date] = Date.parse(val.strip)
            when 'sms_unread'
              @data[:sms] = sms if @data[:sms].nil?
              @data[:sms].unread = val.strip.to_i
            when 'sms_total'
              @data[:sms] = sms if @data[:sms].nil?
              @data[:sms].total = val.strip.to_i
            when 'connected_devices'
              val = val.strip.split(',')
              @data[keysym] = val
            when 'gps_lat', 'gps_long'
              @data[keysym] = val.to_f
            when 'external_ip'
              @data[keysym] = IPAddr.new val.strip
            when 'signal_strength'
              match = val.strip.match(/(\d+)\W\%\W(\-?\d+)\WdBm\W\((\d\w)\)/)
              so = Info::Signal.new(strength: match[1], noise: match[2], network: match[3])
              @data[keysym] = so
            else
              @data[keysym] = val.strip
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

      def product_name
        omni_method
      end

      def signal_strength
        omni_method
      end

      def traffic_modem_tx
        omni_method
      end

      def traffic_modem_rx
        omni_method
      end

      def connection
        omni_method
      end

      def modem_status
        omni_method
      end

      def external_ip
        omni_method
      end

      def date
        omni_method
      end

      def time
        omni_method
      end

      def gps_type
        omni_method
      end

      def gps_lat
        omni_method
      end

      def gps_long
        omni_method
      end

      def sunrise
        omni_method
      end

      def sunset
        omni_method
      end

      def sms
        omni_method
      end

      def connected_devices
        omni_method
      end

      private

      def omni_method
        this_method = caller[0][/`([^']*)'/, 1]
        @data[this_method.to_sym]
      end

      def touch!
        @last_update = Time.now.to_i
      end

    end
  end
end
