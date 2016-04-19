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
        @client = Actor[:client] unless @client
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
        up, down = update_total_traffic_from_router_info
        Traffic::Amount.new down
      end

      # Data upload total traffic amount. Useful with multiple modems.
      #
      # @return [Amount] total amount of uploaded data.
      def up_total
        up, down = update_total_traffic_from_router_info
        Traffic::Amount.new up
      end

      # Update the data in this {Traffic} object.
      def update!
        unless valid?
          begin
            fetch_from_router
          rescue
            @data[:up], @data[:down] = fetch_from_router_info
          end
          touch!
        end
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

      def touch!
        @last_update = Time.now.to_i
      end

      def fetch_from_router
        up, down = [@data[:up], @data[:down]]
        client = Actor[:client]
        client.connect unless client.connected?
        client.authenticate unless client.authenticated?
        string = client.command('traffic')
        # Two Modems
        multiple = string.match(/(\d+)\W(\d+)\W\/\W(\d+)\n(\d+)\W(\d+)\W\/\W(\d+)/)
        # One Modem
        matched = string.match(/(\d+)\W(\d+)\W\/\W(\d+)/)
        if multiple # Two modems found
          if multiple[2]
            down1 = Traffic::Amount.new matched[2].to_i
            down1.sim_id = matched[1]
          end
          if multiple[3]
            up1 = Traffic::Amount.new matched[3].to_i
            up1.sim_id = matched[1]
          end
          if multiple[5]
            down2 = Traffic::Amount.new matched[5].to_i
            down2.sim_id = matched[4]
          end
          if multiple[6]
            up2 = Traffic::Amount.new matched[6].to_i
            up2.sim_id = matched[4]
          end
          @data[:up] = [up1, up2]
          @data[:down] = [down1, down2]
        elsif matched # only one modem found
          if matched[2]
            @data[:down] = Traffic::Amount.new matched[2].to_i
            @data[:down].sim_id = matched[1]
          end
          if matched[3]
            @data[:up] = Traffic::Amount.new matched[3].to_i
            @data[:up].sim_id = matched[1]
          end
        else # Nothing found(?) return data from the Router::Info object
          @data[:up], @data[:down] = fetch_from_router_info
        end
        [@data[:up], @data[:down]]
      end

      def fetch_from_router_info
        up, down = [@data[:up], @data[:down]]
        begin
          up, down = update_total_traffic_from_router_info
        rescue Exception
        end
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
