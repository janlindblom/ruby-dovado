module Dovado
  # Library utilities.
  #
  # @api private
  # @since 1.0.0
  class Utilities
    include Celluloid

    # Convert a key name to symbol.
    #
    # @param name [String] the key name to convert.
    # @return [Symbol] the key name converted to a symbol.
    def self.name_to_sym(name = nil)
      name.downcase.tr(' ', '_').to_sym
    end

    # Build a sentence from an array.
    #
    # Ported from ActiveSupport in file:
    # - activesupport/lib/active_support/core_ext/array/conversions.rb
    #
    # @param [Array] ary the +Array+ to make a sentence of.
    # @param [Hash] options optional settings.
    # @option options [String] :words_connector
    # @option options [String] :two_words_connector
    # @option options [String] :last_word_connector
    def self.array_to_sentence(ary, options = a2s_default_options)
      return '' if ary.length.zero?
      case ary.length
      when 1
        ary[0].to_s.dup
      when 2
        "#{ary[0]}#{options[:two_words_connector]}#{ary[1]}"
      else
        lwc = options[:last_word_connector]
        "#{ary[0...-1].join(options[:words_connector])}#{lwc}#{ary[-1]}"
      end
    end

    private_class_method def self.a2s_default_options
      {
        words_connector: ', ',
        two_words_connector: ' and ',
        last_word_connector: ' and '
      }
    end
  end
end
