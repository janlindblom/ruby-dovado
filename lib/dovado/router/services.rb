
module Dovado
  class Router
    class Services
      include Celluloid
      include Celluloid::Logger
      
      attr_accessor :list
      @list       = nil
      @up_to_date = nil
      
      def initialize(args=nil)
        @list = ThreadSafe::Cache.new
        @up_to_date = false
        unless args.nil?
          args.each do |k,v|
            @list[Dovado::Utilities.name_to_sym(k)] = v
          end
          @up_to_date = true
        end
        debug "Starting up #{self.class.to_s}..."
      end
      
      def create_from_string data_string=nil
        data_array = data_string.split("\n")
        data_array.each do |data_entry|
          entry_array = data_entry.split('=')
          if entry_array.length == 2
            key = entry_array[0].downcase
            val = entry_array[1]
            keysym = Dovado::Utilities.name_to_sym(key)
            @list[keysym] = val
          end
        end
        @up_to_date = true
      end
      
      def valid?
        return @up_to_date
      end
      
    end
  end
end
