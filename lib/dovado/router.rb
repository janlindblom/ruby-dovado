
module Dovado
  class Router
    include Celluloid

    @address = nil
    @connected = nil

    # Create a new [Dovado::Router] object representing an actual Dovado router on the local
    # network.
    #
    def initialize(args=nil)
      
      # Defaults
      @address    = '192.168.0.1'
      user        = nil
      password    = nil
      @connected  = false
      unless args.nil?
        @address  = args[:address]  if args[:address]
        user      = args[:user]     if args[:user]
        password  = args[:password] if args[:password]
      end

      Dovado::Client.supervise as: :client, args: [{
        server:     @address,
        user:       user,
        password:   password
      }]
    end

    def services
      Dovado::Router::Services.supervise as: :router_services unless Actor[:router_services]
      client = Actor[:client]
      router_services = Actor[:router_services]
      unless router_services.valid?
        client.connect
        client.authenticate
        string = client.command('services')
        router_services.create_from_string string
      end
      Dovado::Router::Sms.supervise as: :sms unless Actor[:sms]
      if router_services.list[:sms] == 'enabled'
        Dovado::Router::Info.supervise as: :router_info unless Actor[:router_info]
        router_info = Actor[:router_info]
        router_info.sms.enabled = true
      end
      router_services
    end

    def info
      Dovado::Router::Info.supervise as: :router_info unless Actor[:router_info]
      router_info = Actor[:router_info]
      router_info.local_ip = @address
      client = Actor[:client]
      router_info = Actor[:router_info]
      unless router_info.valid?
        client.connect
        client.authenticate
        info = client.command('info')
        router_info.create_from_string info
      end
      services
      router_info
    end

    def sms
      info.sms
    end

  end
end