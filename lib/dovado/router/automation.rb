
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

      # Create a new Automation object.
      def initialize
        @list = { aliases: [], groups: [] }
      end

      # Turn a device on or off.
      #
      # @param [String] device alias of device.
      # @param [Symbol] on_off either +:on+ or +:off+.
      def turn(device = nil, on_off = :on)
        return if device.nil?
        direction = on_off == :on ? 'on' : 'off'
        client.command("ts turn #{device} #{direction}")
      end

      # Dim a device to given percentage.
      #
      # @param [String] device alias of device.
      # @param [Integer] amount a value in the range +[0..100]+.
      def dim(device = nil, amount = nil)
        return if device.nil? || amount.nil?
        client.command("ts dim #{device} #{amount}")
      end

      # Dim a device to a given percentage after first turning it off.
      #
      # @param [String] device alias of device.
      # @param [Integer] amount a value in the range +[0..100]+.
      def dims(device = nil, amount = nil)
        return if device.nil? || amount.nil?
        client.command("ts dims #{device} #{amount}")
      end

      # Dim a device from a given percentage  to another over the given duration.
      #
      # @param [String] device alias of device.
      # @param [Integer] start_level the starting level, a value in the range +[0..100]+.
      # @param [Integer] stop_level the stopping level, a value in the range +[0..100]+.
      # @param [Integer] duration the time duration over which to dim.
      def dimot(device = nil, _start_level = nil, _stop_level = nil, _duration = nil)
        return if device.nil? || amount.nil?
        client.command("ts dims #{device} #{amount}")
      end

      # Check if home automation is available on this router.
      # @return [Boolean] +true+ or +false+.
      def available?
        Services.setup_supervision!
        Actor[:router_services].update! unless Actor[:router_services].valid?
        Actor[:router_services].home_automation?
      end

      # Update the data in this {Automation} object.
      def update!
        return unless available?

        string = client.command('ts aliases')
        create_from_string :aliases, string
        string = client.command('ts groups')
        create_from_string :groups, string
      end

      # Create new {Automation} data from a string with values from the router
      # API.
      #
      # @param [String] data_string +String+ with data from fetched from the router.
      # @api private
      def create_from_string(list, data_string = nil)
        data_array = data_string.split("\n")
        ao = nil
        go = nil
        @list[list] = []
        @override_validation = true

        data_array.each do |data_entry|
          entry_array = data_entry.split('=')
          next unless entry_array.length == 2
          key = entry_array[0].strip.downcase
          val = entry_array[1].strip.match(/^\'(.*)\'$/)[1]
          keysym = Utilities.name_to_sym(key)
          if list == :aliases
            if key =~ /alias/
              # state 1
              @list[list] << ao unless ao.nil?
              ao = Dovado::Router::Automation::Alias.new
              ao.id = val
            elsif key =~ /protocol/
              # state 2
              ao.protocol = val
            else
              # state 3
              ao.data[keysym] = val
            end
          elsif list == :groups
            if key =~ /group_alias/
              # state 1
              @list[list] << go unless go.nil?
              go = Dovado::Router::Automation::Group.new
              go.id = val
            elsif key =~ /group_participants/
              # state 2
              members = val.split('\ ')
              members.each do |member|
                go.participants << find_alias(member)
              end
            end
          end
        end
        if list == :aliases
          @list[list] << ao
        elsif list == :groups
          @list[list] << go
        end
        @override_validation = nil
        touch!
      end

      # Return the list of known aliases.
      def aliases
        update! unless valid?
        @list[:aliases]
      end

      # Return the list of known groups.
      def groups
        update! unless valid?
        @list[:groups]
      end

      # Find a specific {Alias} object.
      #
      # @param [String] key the id of the {Alias} to find.
      def find_alias(key)
        aliases.find { |a| a.id == key }
      end

      # Find a specific {Group} object.
      #
      # @param [String] key the id of the {Group} to find.
      def find_group(key)
        groups.find { |g| g.id == key }
      end

      # Checks if this {Automation} object is still valid.
      #
      # @return [Boolean] +true+ or +false+.
      def valid?
        return true unless @override_validation.nil?
        return false if @last_update.nil?
        (@last_update + SecureRandom.random_number(9) + 1 <= Time.now.to_i)
      end

      # @api private
      def self.setup_supervision!
        return supervise as: :home_automation, size: 1 unless Actor[:home_automation]
        return supervise as: :home_automation, size: 1 if Actor[:home_automation] && Actor[:home_automation].dead?
      end

      private

      def touch!
        @last_update = Time.now.to_i
      end

      def client
        c = Actor[:client]
        c.connect unless c.connected?
        c.authenticate unless c.authenticated?
        c
      end
    end
  end
end
