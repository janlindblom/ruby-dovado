module Dovado
  # A Dovado Router.
  #
  # @since 1.0.0
  class Router
    # TODO issue:9 Add support for home automation.
    include Celluloid

    # Create a new {Router} object representing an actual Dovado router on the local
    # network.
    #
    # The default router options are:
    # - Address: 192.168.0.1
    # - Port: 6435
    # - User: admin
    # - Password: password
    #
    # These arguments can be passed through environment variables as well, by setting
    # one or more of the following:
    # - +DOVADO_ADDRESS+
    # - +DOVADO_PORT+
    # - +DOVADO_USER+
    # - +DOVADO_PASSWORD+
    #
    # @param [Hash] args optional arguments.
    # @option args [String] :address IP address or DNS name
    # @option args [Integer] :port Port which the router is listening on
    # @option args [String] :user User name
    # @option args [String] :password Password
    def initialize(args=nil)
      # DONE issue:12 Add support for loading argunents from environment.
      @address      = ENV.has_key?('DOVADO_ADDRESS')  ? ENV['DOVADO_ADDRESS']   : '192.168.0.1' # Default address
      @port         = ENV.has_key?('DOVADO_PORT')     ? ENV['DOVADO_PORT'].to_i : 6435
      @user         = ENV.has_key?('DOVADO_USER')     ? ENV['DOVADO_USER']      : "admin"       # Default username
      @password     = ENV.has_key?('DOVADO_PASSWORD') ? ENV['DOVADO_PASSWORD']  : "password"    # Default password
      @connected    = false

      unless args.nil?
        @address  = args[:address]  if args.has_key? :address
        @port     = args[:port]     if args.has_key? :port
        @user      = args[:user]     if args.has_key? :user
        @password  = args[:password] if args.has_key? :password
      end

      supervise_client
    end

    # Fetch services information from the router.
    #
    # @return [Services] The {Services} object
    # @see {Services}
    def services
      Services.setup_supervision!
      client = Actor[:client]
      router_services = Actor[:router_services]

      router_services.update! unless router_services.valid?

      if router_services[:sms] == 'enabled'

        Sms.setup_supervision!
        sms.enabled = true
      end
      router_services
    rescue ConnectionError => ex
      Actor[:client].terminate
      supervise_client
      supervise_services
      raise ex
    end

    # Get the Internet Connection object.
    # @since 1.0.2
    # @return [Internet] the Internet Connection object.
    # @see {Internet}
    def internet
      Internet.setup_supervision!
      Actor[:internet]
    end

    # Get the Data Traffic object.
    # @since 1.0.2
    # @return [Traffic] the Data Traffic object
    # @see {Traffic}
    def traffic
      Traffic.setup_supervision!
      Actor[:traffic]
    end

    # Fetch information from the router.
    #
    # @return [Info] The {Info} object.
    # @see {Info}
    def info
      Info.setup_supervision!
      client = Actor[:client]
      router_info = Actor[:router_info]
      router_info.update! unless router_info.valid?

      services
      router_info
    rescue ConnectionError => ex
      Actor[:client].terminate
      supervise_client
      supervise_info
      raise ex
    end

    # Fetch text messages from the router.
    #
    # @return [Sms] The {Sms} object.
    # @see {Sms}
    def sms
      Sms.supervise as: :sms, size: 1 unless Actor[:sms]
      Actor[:sms]
    end

    private

    def supervise_client
      args = [{
        server:     @address,
        port:       @port,
        user:       @user,
        password:   @password
      }]

      return Client.supervise as: :client, size: 1, args: args unless Actor[:client]
      return Client.supervise as: :client, size: 1, args: args if Actor[:router_services] and Actor[:router_services].dead?
    end

  end
end
