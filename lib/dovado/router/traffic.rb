require 'dovado/router/traffic/amount'

module Dovado
  class Router
    # Traffic Counters.
    #
    # Returns the traffic counters from the router. The developer will have to
    # check the return values to determine if there is traffic for multiple
    # modems available, see {#up} and {#down}, this can be done by checking the
    # type of the return value of these commands.
    #
    # @example Single modem
    #   single_modem_amount = @router.traffic.down
    #
    # @example Two modems
    #   first_modem_amount = @router.traffic.down.first
    #   second_modem_amount = @router.traffic.down.last
    #
    # @example Checking the return value to see if there are multiple modems
    #   traffic_down = @router.traffic.down
    #   if traffic_down.is_a? Dovado::Router::Traffic::Amount
    #     return traffic_down.gigabytes
    #   elsif traffic_down.is_a? Array
    #     return traffic_down.first.gb + traffic_down.last.gb
    #   end
    #
    # @since 1.0.3
    class Traffic
      include Celluloid

      # Create a new {Traffic} object.
      def initialize
        @data = ThreadSafe::Cache.new
        @client ||= Actor[:client]
        @last_update = nil
        @data[:down] = Traffic::Amount.new
        @data[:up] = Traffic::Amount.new
      end

      # Data upload traffic amount.
      #
      # If two modems are used, the returned value is an array with {Amount}
      # objects.
      #
      # @return [Amount, Array<Amount>] amount of uploaded data.
      def up
        update!
        @data[:up]
      end

      # Data download traffic amount.
      #
      # If two modems are used, the returned value is an array with {Amount}
      # objects.
      #
      # @return [Amount, Array<Amount>] amount of downloaded data.
      def down
        update!
        @data[:down]
      end

      # Data download total traffic amount. Useful with multiple modems.
      #
      # @return [Amount] total amount of downloaded data.
      def down_total
        _up, down = update_total_traffic_from_router_info
        Traffic::Amount.new down
      end

      # Data upload total traffic amount. Useful with multiple modems.
      #
      # @return [Amount] total amount of uploaded data.
      def up_total
        up, _down = update_total_traffic_from_router_info
        Traffic::Amount.new up
      end

      # Update the data in this {Traffic} object.
      def update!
        fetch_from_router unless valid?
        touch!
      rescue StandardError
        @data[:up], @data[:down] = fetch_from_router_info
        touch!
      end

      # Determine if this traffic object is valid.
      #
      # @return [Boolean] true or false.
      def valid?
        return false if @last_update.nil?
        (@last_update + SecureRandom.random_number(9) + 1 <= Time.now.to_i)
      end

      # @api private
      def self.setup_supervision!
        supervise as: :traffic, size: 1 unless Actor[:traffic]
      end

      private

      def setup_client!
        @client = Actor[:client]
        @client.connect unless @client.connected?
        @client.authenticate unless @client.authenticated?
      end

      def touch!
        @last_update = Time.now.to_i
      end

      def fetch_from_router
        setup_client!
        string = @client.command('traffic')

        # Two Modems Check
        multiple = string.match(muliple_modems_regex)
        # One Modem Check
        matched = string.match(one_modem_regex)
        # Two modems found:
        process_multiple_modems_traffic!(multiple) if multiple
        # only one modem found:
        process_single_modem_traffic!(matched) if matched

        # Nothing found(?) return data from the Router::Info object
        match = multiple || matched
        @data[:up], @data[:down] = fetch_from_router_info unless match

        [@data[:up], @data[:down]]
      end

      def process_multiple_modems_traffic!(multiple)
        @data[:up] = [setup_match(multiple[3], multiple[1]),
                      setup_match(multiple[6], multiple[4])]
        @data[:down] = [setup_match(multiple[2], multiple[1]),
                        setup_match(multiple[5], multiple[4])]
      end

      def process_single_modem_traffic!(matched)
        @data[:down] = setup_match(matched[2], matched[1]) if matched[2]
        @data[:up] = setup_match(matched[3], matched[1]) if matched[3]
      end

      def setup_match(amount, sim_id)
        amount_object = Traffic::Amount.new amount.to_i
        amount_object.sim_id = sim_id
        amount_object
      end

      def muliple_modems_regex
        %r{(\d+)\W(\d+)\W\/\W(\d+)\n(\d+)\W(\d+)\W\/\W(\d+)}
      end

      def one_modem_regex
        %r{(\d+)\W(\d+)\W\/\W(\d+)}
      end

      def fetch_from_router_info
        up = @data[:up]
        down = @data[:down]
        up, down = update_total_traffic_from_router_info
        [up, down]
      rescue StandardError
        [up, down]
      end

      def update_total_traffic_from_router_info
        Info.setup_supervision! unless Actor[:router_info]
        router_info = Actor[:router_info]
        router_info.update! unless router_info.valid?
        down = Traffic::Amount.new router_info.traffic_modem_rx
        up = Traffic::Amount.new router_info.traffic_modem_tx
        [up, down]
      end
    end
  end
end
