require 'net/telnet'

module Dovado
  class Client
    include Celluloid
    include Celluloid::Logger
    
    @@server = nil
    @address = nil
    @user = nil
    @password = nil
    @@authenticated = nil
    
    def initialize(args=nil)
      # Defaults
      @address   = '192.168.0.1'
      @user     = 'admin'
      @password = 'password'
      unless args.nil?
        @address  = args[:server]   unless    args[:server].nil?
        @user     = args[:user]     unless      args[:user].nil?
        @password = args[:password] unless  args[:password].nil?
      end
      debug "Starting up #{self.class.to_s}..."
    end
    
    def command(text=nil)
      unless text.nil?
        #connect
        #authenticate
    
        res = @@server.puts(text)
        res = @@server.waitfor(/>>\s/)
        #disconnect
        res
      end
    end
    
    def connect
      if @@server.nil?
        @@server = Net::Telnet.new('Host' => @address, 'Port' => 6435, 'Telnetmode' => false, 'Prompt' => />>\s/)
      end
    end
    
    def disconnect
      unless @@server.nil?
        @@server.close
      end
    end
    
    def connected?
      unless @@server.nil?
        true
      else
        false
      end
    end
    
    def authenticate
      unless @@server.nil?
        unless authenticated?
          user = @user unless @user.nil?
          password = @password unless @password.nil?
        
          @@server.cmd("user #{user}")
          @@server.waitfor(/>>\s/)
          @@server.cmd("pass #{password}")
        
          # TODO: verify authentication
          @@authenticated = true
        else
          @@authenticated = false
        end
      else
        @@authenticated = false
      end
    end
    
    def authenticated?
      @@authenticated
    end
    
  end
end
