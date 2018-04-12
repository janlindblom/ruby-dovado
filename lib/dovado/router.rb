module Dovado
  # A Dovado Router.
  #
  # @since 1.0.0
  class Router
    include Celluloid

    # Create a new {Router} object representing an actual Dovado router on the
    #   local network.
    #
    # The default router options are:
    # - Address: 192.168.0.1
    # - Port: 6435
    # - User: admin
    # - Password: password
    #
    # These arguments can be passed through environment variables as well, by
    #   setting one or more of the following:
    #
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
    def initialize(args = nil)
      # Default address or from ENV
      @address = ENV.fetch('DOVADO_ADDRESS', '192.168.0.1')
      # Default port or from ENV
      @port = ENV.fetch('DOVADO_PORT', 6435).to_i
      # Default username or from ENV
      @user = ENV.fetch('DOVADO_USER', 'admin')
      # Default password or from ENV
      @password = ENV.fetch('DOVADO_PASSWORD', 'password')
      @connected = false

      process_args(args) unless args.nil?

      supervise_client
    end

    # Fetch services information from the router.
    #
    # @return [Services] The {Services} object
    # @see {Services}
    def services
      Services.setup_supervision!
      Actor[:router_services].update! unless Actor[:router_services].valid?
      supervise_sms if Actor[:router_services].sms?
      Actor[:router_services]
    rescue ConnectionError => ex
      Actor[:client].terminate
      supervise_client
      supervise_services
      raise ex
    end

    # Fetch and control home automation features.
    #
    # @return [Automation] the {Automation} object
    # @see {Automation}
    # @since 1.0.5
    def home_automation
      Automation.setup_supervision!
      automation = Actor[:home_automation]
      automation.update! unless automation.valid?

      automation
    rescue ConnectionError => ex
      Actor[:client].terminate
      supervise_client
      supervise_services
      raise ex
    end

    def automation
      home_automation
    end

    # Get the Internet Connection object.
    # @since 1.0.2
    # @return [Internet] the Internet Connection object.
    # @see {Internet}
    def internet
      Internet.setup_supervision!
      Actor[:internet]
    end

    # Get the Wifi object.
    # @since 1.0.5
    # @return [Wifi] the Wifi object.
    # @see {Wifi}
    def wifi
      Wifi.setup_supervision!
      Actor[:wifi]
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
      router_info = Actor[:router_info]
      router_info.update! unless router_info.valid?

      services
      router_info
    rescue ConnectionError => ex
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

    def process_args(args)
      @address = args[:address] if args.key? :address
      @port = args[:port] if args.key? :port
      @user = args[:user] if args.key? :user
      @password = args[:password] if args.key? :password
    end

    def supervise_client
      args = [{
        server:     @address,
        port:       @port,
        user:       @user,
        password:   @password
      }]

      return supervised_client(args) unless Actor[:client]
      return supervised_client(args) if services_actor_is_dead?
    end

    def supervise_info
      Dovado::Router::Info.setup_supervision!
    end

    def supervise_sms
      Sms.setup_supervision!
      sms.enabled = true
    end

    def supervised_client(args)
      Client.supervise as: :client, size: 1, args: args
    end

    def services_actor_is_dead?
      Actor[:router_services] && Actor[:router_services].dead?
    end
  end
end
