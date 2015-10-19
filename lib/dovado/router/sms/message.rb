require 'date'

module Dovado
  class Router
    class Sms
      class Message
        include Celluloid
        
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
              case key.strip
              when 'from'
                hash[:from] = val.strip
              when 'alphabet'
                begin
                  hash[:encoding] = Encoding.find(val.strip)
                rescue ArgumentError
                  hash[:encoding] = Encoding::UTF_8
                end
              when 'id'
                hash[:id] = val.strip.to_i
              end
            elsif row_array.length > 2
              sent = row.match(/[Ss]ent\:\W(.*)/)
              hash[:sent] = DateTime.parse(sent[1].strip)
            else
              unless row.downcase =~ /end of sms/
                message_body += "#{row}\n"
              end
            end
          end
          hash[:body] = message_body.tr(">>", "").tr("\x17", "").strip.force_encoding(hash[:encoding])
    
          Dovado::Router::Sms::Message.new(hash)
        end
      end
    end
  end
end
