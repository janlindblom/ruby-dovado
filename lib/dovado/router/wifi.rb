module Dovado
  class Router
    # Wifi.
    #
    # @since 1.0.5
    class Internet
      include Celluloid

      # Create a new {Wifi} object.
      def initialize
        @state = ThreadSafe::Cache.new
        @state[:status] = :off
      end

      # Enable Wifi.
      def on!
        client = Actor[:client]
        client.connect unless client.connected?
        client.authenticate unless client.authenticated?
        client.command("wifi on")
        status = :on
      end

      # Disable Wifi.
      def off!
        client = Actor[:client]
        client.connect unless client.connected?
        client.authenticate unless client.authenticated?
        client.command("wifi off")
        status = :off
      end

      # Check if Wifi is on.
      #
      # @return [Boolean] +true+ if wifi was enabled, false otherwise.
      def on?
        status == :on
      end

      # Check if Wifi is off.
      #
      # @return [Boolean] +true+ if Wifi was disabled, false otherwise.
      def off?
        status == :off
      end

      # Return the current status of Wifi.
      #
      # @return [Symbol] one of: +:on+ or +:off+
      def status
        @state[:status]
      end

      # Set the current status of Wifi.
      #
      # @param [Symbol] value one of: +:on+ or +:off+
      def status=(value)
        @state[:status] = value
      end

      def self.setup_supervision!
        supervise as: :wifi, size: 1 unless Actor[:wifi]
      end

    end
  end
end
