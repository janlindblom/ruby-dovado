module Dovado
  # A Dovado Router.
  # 
  # @since 1.0.0
  class Router
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
    # @param [Hash] args optional arguments.
    # @option args [String] :address IP address or DNS name
    # @option args [Integer] :port Port which the router is listening on
    # @option args [String] :user User name
    # @option args [String] :password Password
    def initialize(args=nil)
      @address    = '192.168.0.1' # Default address
      @port       = 6435
      user        = "admin"       # Default username
      password    = "password"    # Default password
      @connected  = false
      unless args.nil?
        @address  = args[:address]  if args.has_key? :address and !args[:address].nil?
        @port     = args[:port]     if args.has_key? :port and !args[:port].nil?
        user      = args[:user]     if args.has_key? :user and !args[:user].nil?
        password  = args[:password] if args.has_key? :password and !args[:password].nil?
      end

      Client.supervise as: :client, size: 1, args: [{
        server:     @address,
        port:       @port,
        user:       user,
        password:   password
      }]
    end

    # Fetch services information from the router.
    # 
    # @return [Services] The {Services} object
    # @see {Services}
    def services
      Services.supervise as: :router_services, size: 1 unless Actor[:router_services]
      client = Actor[:client]
      router_services = Actor[:router_services]

      unless router_services.valid?
        client.connect unless client.connected?
        client.authenticate unless client.authenticated?
        string = client.command('services')
        router_services.create_from_string string
      end

      if router_services[:sms] == 'enabled'
        
        Sms.supervise as: :sms, size: 1 unless Actor[:sms]
        sms.enabled = true
      end
      router_services
    end

    # Get the Internet Connection object.
    # @since 1.0.2
    # @return [Internet] the Internet Connection object.
    # @see {Internet}
    def internet
      Internet.supervise as: :internet, size: 1 unless Actor[:internet]
      Actor[:internet]
    end

    # Get the Data Traffic object.
    # @since 1.0.2
    # @return [Traffic] the Data Traffic object
    # @see {Traffic}
    def traffic
      Traffic.supervise as: :traffic, size: 1 unless Actor[:traffic]
      Actor[:traffic]
    end

    # Fetch information from the router.
    # 
    # @return [Info] The {Info} object.
    # @see {Info}
    def info
      Info.supervise as: :router_info, size: 1 unless Actor[:router_info]
      router_info = Actor[:router_info]
      client = Actor[:client]
      router_info = Actor[:router_info]
      unless router_info.valid?
        client.connect unless client.connected?
        client.authenticate unless client.authenticated?
        info = client.command('info')
        router_info.create_from_string info
      end
      services
      router_info
    end

    # Fetch text messages from the router.
    # 
    # @return [Sms] The {Sms} object.
    # @see {Sms}
    def sms
      Sms.supervise as: :sms, size: 1 unless Actor[:sms]
      Actor[:sms]
    end

  end
end