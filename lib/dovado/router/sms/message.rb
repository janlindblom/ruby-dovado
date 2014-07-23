require 'date'

module Dovado
  class Router
    class Sms
      class Message
        include Celluloid
        include Celluloid::Logger
        
        attr_reader :id, :body, :pdus, :from, :sent, :encoding
  
        @id = nil
        @body = nil
        @pdus = nil
        @from = nil
        @sent = nil
        @encoding = nil
  
        def initialize(args=nil)
          unless args.nil?
            @id = args[:id] unless args[:id].nil?
            @body = args[:body] unless args[:body].nil?
            @pdus = args[:pdus] unless args[:pdus].nil?
            @from = args[:from] unless args[:from].nil?
            @sent = args[:sent] unless args[:sent].nil?
            @encoding = args[:encoding] unless args[:encoding].nil?
          end
          debug "Starting up #{self.class.to_s}..."
        end
  
        def self.from_string string=nil
          hash = ThreadSafe::Cache.new
          message_body = ""
          array = string.split("\n")
          array.each do |row|
            row_array = row.split(':')
            if row_array.length == 2
              key = row_array[0].downcase
              val = row_array[1]
              case key
              when 'from'
                hash[:from] = val
              when 'sent'
                hash[:sent] = DateTime.parse(val)
              when 'alphabet'
                hash[:encoding] = val
              when 'id'
                hash[:id] = val
              else
                # do nothing
              end
        
            end
            unless row.downcase =~ /end of sms/
              message_body += "#{row}\n"
            end
          end
          hash[:body] = message_body
    
          Dovado::Router::Sms::Message.new(hash)
        end
      end
    end
  end
end
