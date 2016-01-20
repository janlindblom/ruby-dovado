require 'net/telnet'

module Dovado
  # Internal API client.
  #
  # @api private
  # @since 1.0.0
  class Client
    include Celluloid

    # Create a new {Client} object.
    #
    # The default options are:
    # - Address: 192.168.0.1
    # - Port: 6435
    # - User: admin
    # - Password: password
    #
    # @param [Hash] args option arguments.
    # @option args [String] :server The server (router) address.
    # @option args [Integer] :port The server (router) port.
    # @option args [String] :user The user name.
    # @option args [String] :password The user password.
    def initialize(args=nil)
      # Defaults
      @address  = '192.168.0.1'
      @user     = 'admin'
      @password = 'password'
      @port     = 6435
      unless args.nil?
        @address  = args[:server]   if args.has_key? :server
        @port     = args[:port]     if args.has_key? :port
        @user     = args[:user]     if args.has_key? :user
        @password = args[:password] if args.has_key? :password
      end
    end

    # Run a command on the router.
    #
    # @param [String] text the command to run.
    # @raise [ConnectionError] if there is an error in the communication with
    #   the router.
    def command(text=nil)
      perform_command text
    rescue IOError
      disconnect
      connect unless connected?
      authenticate unless authenticated?
      perform_command text
    rescue Net::ReadTimeout => ex
      disconnect
      connect unless connected?
      authenticate unless authenticated?
      perform_command text
      #raise ConnectionError.new "Error connecting to router: #{ex.message}"
    end

    # Connect to the router.
    # @raise [ConnectionError] if there is an error in the communication with
    #   the router.
    def connect
      if @server.nil?
        @server = Net::Telnet.new(
          'Host' => @address,
          'Port' => @port,
          'Telnetmode' => false,
          'Prompt' => />>\s/)
      end
    rescue Net::OpenTimeout => ex
      raise ConnectionError.new "Error connecting to router: #{ex.message}"
    rescue IOError => ex
      disconnect
      raise ConnectionError.new "Error connecting to router: #{ex.message}"
    rescue Net::ReadTimeout => ex
      disconnect
      raise ConnectionError.new "Error connecting to router: #{ex.message}"
    end

    # Disconnect from the router.
    def disconnect
      unless @server.nil?
        @server.cmd "quit"
        @server.close
      end
      @authenticated = false
      @server = nil
    end

    # Check if we are connected to the router.
    #
    # @return [Boolean] +true+ or +false+.
    def connected?
      unless @server.nil?
        true
      else
        false
      end
    end

    # Authenticate user.
    #
    # @todo Verify authentication properly.
    # @raise [ConnectionError] if there is an error in the communication with
    #   the router.
    def authenticate
      perform_authentication
    rescue IOError
      disconnect
      connect unless connected?
      perform_authentication
    rescue Net::ReadTimeout => ex
      disconnect
      connect unless connected?
      perform_authentication
      #raise ConnectionError.new "Error connecting to router: #{ex.message}"
    end

    # Check if we're authenticated.
    #
    # @return [Boolean] +true+ or +false+.
    def authenticated?
      @authenticated
    end

    private

    def perform_command(text)
      unless text.nil?
        res = @server.puts(text)
        res = @server.waitfor(/>>\s/)
        res
      end
    end

    def perform_authentication
      if connected?
        unless authenticated?
          raise ArgumentError.new "Username cannot be nil" if @user.nil?
          raise ArgumentError.new "Password cannot be nil" if @password.nil?

          @server.cmd "user #{@user}"
          @server.waitfor />>\s/
          @server.cmd "pass #{@password}"

          # TODO: Verify authentication for real. How? Wait for a prompt or parse the response to a successful authentication.
          @authenticated = true
        else
          @authenticated = false
        end
      else
        @authenticated = false
      end
    end

  end
end
