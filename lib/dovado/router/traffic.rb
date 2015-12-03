require 'dovado/router/traffic/amount'

module Dovado
  class Router
    # Traffic Counters.
    # 
    # @since 1.0.3
    class Traffic
      include Celluloid

      # Create a new {Internet} object.
      def initialize
        @data = ThreadSafe::Cache.new
        @client = Actor[:client] unless @client
        @last_update = nil
        @data[:down] = Traffic::Amount.new
        @data[:up] = Traffic::Amount.new
      end

      # Data upload traffic amount.
      # 
      # @return [Amount] amount of uploaded data.
      def up
        update!
        @data[:up]
      end

      # Data download traffic amount.
      # 
      # @return [Amount] amount of downloaded data.
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
            up, down = fetch_from_router
          rescue
            up, down = fetch_from_router_info
          end
          @data[:down] = Traffic::Amount.new down
          @data[:up] = Traffic::Amount.new up
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
        matched = string.match(/(\d+)\W(\d+)\W\/\W(\d+)/)
        if matched
          up = matched[3].to_i if matched[3]
          down = matched[2].to_i if matched[2]
        else
          up, down = fetch_from_router_info
        end
        [up, down]
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
        down = router_info.traffic_modem_rx
        up = router_info.traffic_modem_tx
        [up, down]
      end

    end
  end
end
