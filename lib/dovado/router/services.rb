require "time"
require "thread_safe"

module Dovado
  class Router
    # Router Services.
    # 
    # @since 1.0.0
    class Services
      include Celluloid

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

      private

      def touch!
        @last_update = Time.now.to_i
      end

    end
  end
end
