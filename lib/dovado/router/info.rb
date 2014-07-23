require 'date'
require 'time'
require 'socket'

module Dovado
  class Router
    class Info
      include Celluloid
      include Celluloid::Logger
      
      @data = nil
      @up_to_date = false
    
      def initialize(args=nil)
        # Defaults
        @data = ThreadSafe::Cache.new
        @data[:local_ip] = Addrinfo.ip '192.168.0.1'
        
        @up_to_date = false
        unless args.nil?
          @data = args
        end
        debug "Starting up #{self.class.to_s}..."
      end
    
      def create_from_string data_string=nil
        data_array = data_string.split("\n")
        data_array.each do |data_entry|
          entry_array = data_entry.split('=')
          if entry_array.length == 2
            key = entry_array[0].downcase
            val = entry_array[1]
            keysym = Dovado::Utilities.name_to_sym(key)
            case key
            when 'time'
              @data[:time] = Time.parse(val)
            when 'date'
              @data[:date] = Date.parse(val)
            when 'sms_unread'
              @data[:sms] = Dovado::Router::Sms.new if @data[:sms].nil?
              @data[:sms].unread = val.to_i
            when 'sms_total'
              @data[:sms] = Dovado::Router::Sms.new if @data[:sms].nil?
              @data[:sms].total = val.to_i
            when 'connected_devices'
              val = val.split(',')
              @data[keysym] = val
            when 'external_ip'
              val = Addrinfo.ip(val)
              @data[keysym] = val
            else
              @data[keysym] = val
            end
          end
        end
        @up_to_date = true
      end
      
      # Determine if this info object is valid.
      #
      # @return [Boolean] true or false.
      def valid?
        return @up_to_date
      end
    
      # Get the firmware version of this Dovado router.
      #
      # @return [String] The firmware version of this Dovado router.
      def firmware_version
        @data[:firmware_revision]
      end
    
      def firmware_version= firmware_revision=nil
        @data[:firmware_revision] = firmware_revision
      end
    
      # Checks if there is new firmware available.
      #
      # @return [Boolean] true or false.
      def new_firmware?
        @data[:new_firmware_available].downcase == 'no' ? false : true
      end
    
      def new_firmware= new_firmware=nil
        @data[:new_firmware_available] = new_firmware
      end
    
      # Get the API version on this Dovado router.
      #
      # @return [String] The API version on this Dovado router.
      def api_version
        @data[:api_version]
      end
    
      def api_version= api_version=nil
        @data[:api_version] = api_version
      end
    
      # Get the model name of this Dovado router.
      #
      # @return [String] The model name of this Dovado router.
      def model
        @data[:product_name]
      end
    
      def model= model=nil
        @data[:product_name] = model
      end
    
      def signal_strength
        @data[:signal_strength]
      end
    
      def signal_strength= signal_strength=nil
        @data[:signal_strength] = signal_strength
      end
    
      def traffic_modem_up
        @data[:traffic_modem_tx]
      end
    
      def traffic_modem_up= traffic_modem_up=nil
        @data[:traffic_modem_tx] = traffic_modem_up
      end
    
      def traffic_modem_down
        @data[:traffic_modem_rx]
      end
    
      def traffic_modem_down= traffic_modem_down=nil
        @data[:traffic_modem_rx] = traffic_modem_down
      end
    
      def connection
        @data[:connection]
      end
    
      def connection= connection=nil
        @data[:connection] = connection
      end
    
      def modem_status
        @data[:modem_status]
      end
    
      def modem_status= modem_status=nil
        @data[:modem_status] = modem_status
      end
    
      def external_ip
        @data[:external_ip]
      end
    
      def external_ip= external_ip=nil
        @data[:external_ip] = external_ip
      end
      
      def local_ip
        @data[:local_ip]
      end
      
      def local_ip= ip=nil
        @data[:local_ip] = Addrinfo.ip(ip) unless ip.nil?
      end
    
      def date
        @data[:date]
      end
    
      def date= date=nil
        @data[:date] = date
      end
    
      def time
        @data[:time]
      end
    
      def time= time=nil
        @data[:time] = time
      end
    
      def sms
        unless @data[:sms].nil?
          @data[:sms] = Dovado::Router::Sms.new
        end
        @data[:sms]
      end
    
      def sms= sms=nil
        @data[:sms] = sms
      end
    
      def connected_devices
        @data[:connected_devices]
      end
    
      def connected_devices= connected_devices=nil
        @data[:connected_devices] = connected_devices
      end

    end
  end
end
