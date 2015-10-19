module Dovado
  class Utilities
    include Celluloid
    
    # Convert a key name to symbol.
    # 
    # @param name [String] the key name to convert.
    # @return [Symbol] the key name converted to a symbol.
    def self.name_to_sym(name=nil)
      name.downcase.tr(' ', '_').to_sym
    end
  end
end