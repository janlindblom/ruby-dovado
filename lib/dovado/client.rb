require 'net/telnet'

module Dovado
  class Client
    @server = nil
    @user = nil
    @password = nil
    @authenticated = nil
    
    def initialize(args=nil)
      # Defaults
      @server   = '192.168.0.1'
      @user     = 'admin'
      @password = 'password'
      @authenticated = false
      unless args.nil?
        @server   = args[:server]   unless    args[:server].nil?
        @user     = args[:user]     unless      args[:user].nil?
        @password = args[:password] unless  args[:password].nil?
      end
    end
    
    def authenticate
      unless @server.nil?
        user = @user unless @user.nil?
        password = @password unless @password.nil?
        
        @server.cmd("user #{user}")
        @server.cmd("pass #{password}")
        
        # TODO: verify authentication
        @authenticated = true
      else
        @authenticated = false
      end
    end
    
    def command(text=nil)
      return false if text.nil?
      connect unless connected?
      authenticate unless authenticated?
      
      res = @server.cmd(text)
      res = @server.waitfor(/>>/)
      return res
    end
    
    def connect
      @server = Net::Telnet::new('Host' => @server, 'Port' => 6435, 'Telnetmode' => false, 'Prompt' => />>/n)
      return true if @server
      return false
    end
    
    def disconnect
      unless @server.nil?
        return @server.close
      end
      return false
    end
    
    def connected?
      not @server.nil?
    end
    
    def authenticated?
      @authenticated
    end
    
  end
end
