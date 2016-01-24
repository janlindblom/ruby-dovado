
module Dovado
  class Router
    # Home Automation features.
    #
    # @since 1.0.5
    class Automation
      # DOING:0 issue:9 case:10993 Started work on automation features.
      include Celluloid

      # Defined groups on the router.
      attr_reader :groups

      # Defined aliases on the router.
      attr_reader :aliases

      # Check if home automation is available on this router.
      # @return [Boolean] +true+ or +false+.
      def available?
        Services.setup_supervision!
      end

      # Update the data in this {Automation} object.
      def update!
        return unless available?
        client = Actor[:client]
        client.connect unless client.connected?
        client.authenticate unless client.authenticated?
        string = client.command('ts aliases')
        create_from_string :aliases, string
      end

      # Create new {Automation} data from a string with values from the router
      # API.
      #
      # @param [String] data_string +String+ with data from fetched from the
      #   router.
      def create_from_string(list, data_string=nil)
        data_array = data_string.split("\n")
        data_array.each do |data_entry|
          entry_array = data_entry.split('=')
          if entry_array.length == 2
            key = entry_array[0].downcase
            val = entry_array[1]
            keysym = Utilities.name_to_sym(key)
            @list[list][keysym] = val
          end
        end
        touch!
      end

      # Checks if this {Automation} object is still valid.
      #
      # @return [Boolean] +true+ or +false+.
      def valid?
        return false if @last_update.nil?
        (@last_update + SecureRandom.random_number(9) + 1 <= Time.now.to_i)
      end

      # @api private
      def self.setup_supervision!
        return supervise as: :home_automation, size: 1 unless Actor[:home_automation]
        return supervise as: :home_automation, size: 1 if Actor[:home_automation] and Actor[:home_automation].dead?
      end

      private

      def touch!
        @last_update = Time.now.to_i
      end
    end
  end
end
