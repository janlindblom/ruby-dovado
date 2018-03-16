require 'dovado/router/automation/protocol/unsupported_protocol_error'
require 'dovado/router/automation/protocol/internet'
require 'dovado/router/automation/protocol/wake_on_lan'
require 'dovado/router/automation/protocol/arctech'
require 'dovado/router/automation/protocol/brateck'
require 'dovado/router/automation/protocol/everflourish'
require 'dovado/router/automation/protocol/everflourish_selflearning'
require 'dovado/router/automation/protocol/fuhaote'
require 'dovado/router/automation/protocol/gembird'
require 'dovado/router/automation/protocol/ikea'
require 'dovado/router/automation/protocol/nexa'
require 'dovado/router/automation/protocol/nexa_dimmer'
require 'dovado/router/automation/protocol/nexa_selflearning'
require 'dovado/router/automation/protocol/proove'
require 'dovado/router/automation/protocol/risingsun'
require 'dovado/router/automation/protocol/risingsun_selflearning'
require 'dovado/router/automation/protocol/sartano'
require 'dovado/router/automation/protocol/upm'
require 'dovado/router/automation/protocol/waveman'

module Dovado
  class Router
    class Automation
      # Automation alias protocol object.
      #
      # @since 1.0.5
      class Protocol

        def self.create_from_string(mnemonic)
          case mnemonic
          when "INTERNET"
            Dovado::Router::Automation::Protocol::Internet.new
          when "WOL"
            Dovado::Router::Automation::Protocol::WakeOnLan.new
          when "ARCTECH"
            Dovado::Router::Automation::Protocol::Arctech.new
          when "BRATECK"
            Dovado::Router::Automation::Protocol::Brateck.new
          when "EVERFLOURISH"
            Dovado::Router::Automation::Protocol::Everflourish.new
          when "EVERSELFLEARNING"
            Dovado::Router::Automation::Protocol::EverflourishSelflearning.new
          when "FUHAOTE"
            Dovado::Router::Automation::Protocol::Fuhaote.new
          when "GEMBIRD"
            Dovado::Router::Automation::Protocol::Gembird.new
          when "IKEA"
            Dovado::Router::Automation::Protocol::Ikea.new
          when "NEXA"
            Dovado::Router::Automation::Protocol::Nexa.new
          when "NEXADIMMER"
            Dovado::Router::Automation::Protocol::NexaDimmer.new
          when "NEXASELFLEARNING"
            Dovado::Router::Automation::Protocol::NexaSelflearning.new
          when "PROOVE"
            Dovado::Router::Automation::Protocol::Proove.new
          when "RISINGSUN"
            Dovado::Router::Automation::Protocol::Risingsun.new
          when "RISINGSUNSELFLEARNING"
            Dovado::Router::Automation::Protocol::RisingsunSelflearning.new
          when "SARTANO"
            Dovado::Router::Automation::Protocol::Sartano.new
          when "UPM"
            Dovado::Router::Automation::Protocol::UPM.new
          when "WAVEMAN"
            Dovado::Router::Automation::Protocol::Waveman.new
          else
            raise Dovado::Router::Automation::Protocol::UnsupportedProtocolError.new("Unsupported protocol: #{mnemonic}.")
          end
        end
      end
    end
  end
end
