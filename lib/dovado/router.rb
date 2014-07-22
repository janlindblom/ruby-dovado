module Dovado
  class Router
    @client = nil
    @router_info = nil
    @address = nil
    @connected = nil

    # Get the model name of this Dovado router.
    #
    # @return [String] The model name of this Dovado router.
    def initialize(args)
      # Defaults
      @address    = '192.168.0.1'
      user        = nil
      password    = nil
      @client     = nil
      @connected  = false
      unless args.nil?
        @address  = args[:address]  if args[:address]
        user      = args[:user]     if args[:user]
        password  = args[:password] if args[:password]
      end

      @router_info  = Dovado::Router::Info.new
      @router_info.local_ip = @address
      
      @client       = Dovado::Client.new({
        server:     @address,
        user:       user,
        password:   password
        }) if @client.nil?
    end

    def info
      unless @router_info.valid?
        @client.connect
        info = @client.command('info')
        puts "got from info command: #{info.inspect}"
        @router_info.create_from_string info
        @client.disconnect
      end
      @router_info
    end
    
    def connect
      @connected = true if @client.connect
      @connected
    end
    
    def disconnect
      @connected = false if @client.disconnect
      @connected
    end

  end
end