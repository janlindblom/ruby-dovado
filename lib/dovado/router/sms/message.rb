require 'date'

module Dovado
  class Router
    class Sms
      # A text message (SMS).
      #
      # @since 1.0.0
      class Message
        include Celluloid

        # Message Id.
        # @return [String,Integer,Symbol]
        attr_reader :id
        # Message body.
        # @return [String]
        attr_reader :body
        # Message PDU's.
        # @return [Array]
        attr_reader :pdus
        # Message sender.
        # @return [String]
        attr_reader :from
        # Message sender type
        # @return [Array<String>]
        attr_reader :sender_type
        # Message send timestamp.
        # @return [Time]
        attr_reader :sent
        # Message text encoding.
        # @return [Encoding]
        attr_reader :encoding

        # Create a new {Message} object.
        #
        # @param [Hash] args arguments.
        # @option args [Integer,String,Symbol] :id Message Id.
        # @option args [String] :body Message body.
        # @option args [Array] :pdus Message PDU's.
        # @option args [String] :from Message sender.
        # @option args [DateTime] :sent Message send timestamp.
        # @option args [Encoding] :encoding Message text encoding.
        def initialize(args = nil)
          unless args.nil?
            @id = args[:id] unless args[:id].nil?
            @body = args[:body] unless args[:body].nil?
            @pdus = args[:pdus] unless args[:pdus].nil?
            @from = args[:from] unless args[:from].nil?
            @sender_type ||= args[:sender_type]
            @sent = args[:sent] unless args[:sent].nil?
            @encoding = args[:encoding] unless args[:encoding].nil?
          end
        end

        # Create a new {Message} object from a +String+.
        #
        # @param [String] string message data to create object from.
        # @return [Message] a new {Message} object.
        def self.from_string(string)
          hash = ThreadSafe::Cache.new
          message_body = ''
          array = string.split("\n")
          array.each do |row|
            row_array = row.split(':')
            if row_array.length == 2
              key = row_array[0].downcase
              val = row_array[1]
              case key.strip
              when 'from'
                hash[:from] = val.strip
              when 'from_toa'
                hash[:sender_type] = val.strip.split(',').map(&:strip)
              when 'alphabet'
                hash[:encoding] = process_encoding(val.strip)
              when 'id'
                hash[:id] = val.strip.to_i
              end
            elsif row_array.length > 2
              sent = row.match(/[Ss]ent\:\W(.*)/)
              hash[:sent] = Time.parse(sent[1].strip) unless sent.nil?
            else
              message_body += "#{row}\n" unless row.downcase =~ /end of sms/
            end
          end
          hash[:body] = message_body.tr('>>', '').tr("\x17", '')
                                    .strip.force_encoding(hash[:encoding])

          Message.new(hash)
        end

        private

        def process_encoding(value)
          Encoding.find(value)
        rescue ArgumentError
          Encoding::UTF_8
        end
      end
    end
  end
end
