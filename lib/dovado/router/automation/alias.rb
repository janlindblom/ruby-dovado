module Dovado
  class Router
    class Automation
      class Alias
        attr_accessor :id
        attr_accessor :protocol
        attr_accessor :data

        def initialize(args=nil)
          unless args.nil?
            @id = args[:id] if args.key? :id
            @protocol = args[:protocol] if args.key? :protocol
          end
          @data = {}
        end

        def turn_on
          turn(:on)
        end

        def turn_off
          turn(:off)
        end

        def turn(on_off)
          home_automation.turn(id, on_off)
        end

        def dim(amount)
          home_automation.dim(id, amount)
        end

        def dims(amount)
          home_automation.dims(id, amount)
        end

        def dimot(start_level, stop_level, duration)
          home_automation.dimot(start_level, stop_level, duration)
        end

        # Checks if this {Alias} object is valid.
        #
        # @return [Boolean] +true+ or +false+.
        def valid?

        end

        private

        def home_automation
          Automation.setup_supervision!
          Actor[:home_automation]
        end

      end
    end
  end
end
