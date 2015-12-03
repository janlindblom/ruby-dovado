require "time"
require "thread_safe"

module Dovado
  class Router
    # Router Services.
    # 
    # @since 1.0.0
    class Services
      include Celluloid

      # Get status of sms service
      # 
      # @return [String] a string with "enabled" or "disabled"
      # @since 1.0.3
      attr_reader :sms

      # Get status of home automation service
      # 
      # @return [String] a string with "enabled" or "disabled"
      # @since 1.0.3
      attr_reader :home_automation

      # Create a new {Services} object.
      # 
      # @param [Hash] args optional argiments
      def initialize(args=nil)
        @list = ThreadSafe::Cache.new
        @last_update = nil
        unless args.nil?
          args.each do |k,v|
            @list[Utilities.name_to_sym(k)] = v
          end
          touch!
        end
      end

      # Update the data in this {Services} object.
      def update!
        client = Actor[:client]
        client.connect unless client.connected?
        client.authenticate unless client.authenticated?
        string = client.command('services')
        create_from_string string
      end

      # Create a new {Services} object from a string with values from the router
      # API.
      # 
      # @param [String] data_string +String+ with data from fetched from the
      #   router.
      # @return [Services] a new {Services} object.
      def create_from_string(data_string=nil)
        data_array = data_string.split("\n")
        data_array.each do |data_entry|
          entry_array = data_entry.split('=')
          if entry_array.length == 2
            key = entry_array[0].downcase
            val = entry_array[1]
            keysym = Utilities.name_to_sym(key)
            @list[keysym] = val
          end
        end
        touch!
      end

      # Fetch an entry from the {Services} object.
      # 
      # @param [Symbol] key The key to fetch.
      def [](key)
        @list[key]
      end

      # Fetch the list of entries in the {Services} object.
      # 
      # @return [Array<Symbol>]
      def keys
        @list.keys
      end

      # Check if the {Services} object has a given key.
      # 
      # @param [Symbol] key the key to check for.
      # @return [Boolean] +true+ or +false+
      def has_key?(key)
        keys.member?(key)
      end

      # Checks if this {Services} object is still valid.
      # 
      # @return [Boolean] +true+ or +false+.
      def valid?
        return false if @last_update.nil?
        (@last_update + SecureRandom.random_number(9) + 1 <= Time.now.to_i)
      end

      def sms
        @list[:sms] if has_key? :sms
      end

      # Boolean check if sms service is enabled
      # 
      # @return [Boolean] +true+ or +false+
      # @since 1.0.3
      def sms?
        sms ? (sms == "enabled") : false
      end

      def home_automation
        @list[:homeautomation] if has_key? :homeautomation
      end

      # Boolean check if home automation is enabled
      # 
      # @return [Boolean] +true+ or +false+
      # @since 1.0.3
      def home_automation?
        home_automation ? (home_automation == "enabled") : false
      end

      # @api private
      def self.setup_supervision!
        return supervise as: :router_services, size: 1 unless Actor[:router_services]
        return supervise as: :router_services, size: 1 if Actor[:router_services] and Actor[:router_services].dead?
      end

      private

      def touch!
        @last_update = Time.now.to_i
      end

    end
  end
end
