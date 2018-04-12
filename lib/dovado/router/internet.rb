module Dovado
  class Router
    # Internet Connection.
    #
    # @since 1.0.3
    class Internet
      include Celluloid

      # Create a new {Internet} object.
      def initialize
        @state = ThreadSafe::Cache.new
        @state[:status] = :offline
      end

      # Enable internet connection.
      def on!
        client = Actor[:client]
        client.connect unless client.connected?
        client.authenticate unless client.authenticated?
        client.command('internet on')
        status = :online
      end

      # Disable internet connection.
      def off!
        client = Actor[:client]
        client.connect unless client.connected?
        client.authenticate unless client.authenticated?
        client.command('internet off')
        status = :offline
      end

      # Check if the internet connection is up.
      #
      # @return [Boolean] +true+ if internet was enabled, false otherwise.
      def on?
        status == :online
      end

      # Check if the internet connection is down.
      #
      # @return [Boolean] +true+ if internet was disabled, false otherwise.
      def off?
        status == :offline
      end

      # Return the current status of the internet connection.
      #
      # @return [Symbol] one of: +:online+ or +:offline+
      def status
        @state[:status]
      end

      # Set the current status of the internet connection.
      #
      # @param [Symbol] value one of: +:online+ or +:offline+
      def status=(value)
        @state[:status] = value
      end

      def self.setup_supervision!
        supervise as: :internet, size: 1 unless Actor[:internet]
      end
    end
  end
end
