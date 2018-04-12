module Dovado
  class Router
    class Info
      # An ISP/operator.
      #
      # Extend this class to create a new operator or use it as it is.
      #
      # @example Extending the Operator class
      #   class MyOperator < Dovado::Router::Info::Operator
      #     def initialize
      #       super(name: "MyOperator", number: "s1234", commands: {data_remaining: "quota"})
      #     end
      #   end
      #
      # @example Using the Operator class as it is
      #   my_operator = Dovado::Router::Info::Operator.new(name: "MyOperator", number: "s1234", commands: {data_remaining: "quota"})
      #
      # @since 1.0.0
      class Operator
        include Celluloid

        # Number to send messages to for the operator.
        # @return [String]
        attr_accessor :number
        # Name of the operator.
        # @return [String]
        attr_accessor :name
        # List of commands supported by the operator.
        # @return [Hash]
        attr_accessor :commands

        # Create a new Operator object.
        #
        # @example Initializing with custom commands
        #   my_commands = { data_remaining: "datamängd".encode("UTF-8") }
        #   my_operator = Operator.new(name: "MyOperator", number: "s1234", commands: my_commands)
        #
        # @param [Hash] args optional arguments
        # @option args [String] :number The recipient number for this operator.
        #   Use the prefix +s+ to indicate a "short" number, e.g "s4466".
        # @option args [String] :name Name of the operator.
        # @option args [Hash] :commands Supported commands.
        def initialize(args = nil)
          self.name = 'Unknown'
          prepare_args(args) unless args.nil?
        end

        # Default commands for an operator.
        def self.default_commands
          commands = {}
          required_commands.each do |command|
            commands[command] = ''
          end
          commands
        end

        private

        def prepare_args(args)
          @number = ''
          @name = 'NoOperator'
          @commands = Operator.default_commands
          @number = args[:number] unless args[:number].nil?
          @name = args[:name] unless args[:name].nil?
          check_for_missing_keys(args[:commands]) unless args[:commands].nil?
          @commands = args[:commands]
        end

        def check_for_missing_keys(commands)
          missing_keys = []
          Operator.required_commands.each do |req|
            missing_keys << req unless commands.key?(req)
          end
          raise_missing_keys_error(missing_keys) unless missing_keys.empty?
          missing_keys
        end

        def raise_missing_keys_error(missing_keys)
          missing = Utilities.array_to_sentence(missing_keys)
          raise ArgumentError, "Missing required keys in hash: #{missing}"
        end

        def self.required_commands
          [
            :data_remaining
          ]
        end
      end
    end
  end
end
