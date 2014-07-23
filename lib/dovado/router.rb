
module Dovado
  class Router
    include Celluloid
    include Celluloid::Logger

    @address = nil
    @connected = nil

    # Create a new [Dovado::Router] object representing an actual Dovado router on the local
    # network.
    #
    def initialize(args=nil)
      debug "Starting up #{self.class.to_s}..."
      
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

      Dovado::Client.supervise_as :client, {
        server:     @address,
        user:       user,
        password:   password
      }

      Dovado::Router::Info.supervise_as :router_info
      router_info = Actor[:router_info]
      router_info.local_ip = @address

      Dovado::Router::Services.supervise_as :router_services
      #info "Starting up..."
    end

    def services
      client = Actor[:client]
      router_services = Actor[:router_services]
      unless router_services.valid?
        client.connect
        client.authenticate
        string = client.command('services')
        router_services.create_from_string string
      end
      if router_services.list[:sms] == 'enabled'
        router_info = Actor[:router_info]
        router_info.sms.enabled = true
      end
      router_services
    end

    def info
      client = Actor[:client]
      router_info = Actor[:router_info]
      unless router_info.valid?
        client.connect
        client.authenticate
        info = client.command('info')
        router_info.create_from_string info
      end
      router_info
    end

    def sms
      client = Actor[:client]
      router_info = Actor[:router_info]
      if router_info.valid?
        unless router_info.sms.valid?
          client.connect
          client.authenticate
          unless Actor[:sms]
            Dovado::Router::Sms.supervise_as :sms
          end
          sms = Actor[:sms]
          sms.async.create_from_string(client.command('sms list'))
          router_info.sms = sms
          sms.load_messages
        end
      end
      router_info.sms
    end

  end
end