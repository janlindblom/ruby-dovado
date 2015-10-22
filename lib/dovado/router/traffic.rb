require 'dovado/router/traffic/amount'

module Dovado
  class Router
    # Traffic Counters.
    # 
    # @since 1.0.2
    class Traffic
      include Celluloid

      # Create a new {Internet} object.
      def initialize
        @data = ThreadSafe::Cache.new
        @client = Actor[:client] unless @client
        @last_update = nil
        @data[:down] = Traffic::Amount.new(0)
        @data[:up] = Traffic::Amount.new(0)
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

      # Update this {Traffic} object.
      def update!
        unless valid?
          begin
            up, down = fetch_from_router
          rescue
            up, down = fetch_from_router_info
          end
          @data[:down] = Traffic::Amount.new(down)
          @data[:up] = Traffic::Amount.new(up)
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
        Info.supervise as: :router_info, size: 1 unless Actor[:router_info]
        router_info = Actor[:router_info]
        down = router_info[:traffic_modem_rx].to_i if router_info.has_key? :traffic_modem_rx
        up = router_info[:traffic_modem_rx].to_i if router_info.has_key? :traffic_modem_tx
        [up, down]
      end

    end
  end
end
