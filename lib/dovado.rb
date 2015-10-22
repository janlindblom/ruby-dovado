require 'celluloid/current'

# The Ruby-Dovado library.
# 
# @author Jan Lindblom <janlindblom@fastmail.fm>
# @version 1.0.3a
module Dovado
end

require 'dovado/connection_error'
require 'dovado/utilities'
require 'dovado/client'

require 'dovado/router'

require 'dovado/router/services'

require 'dovado/router/info'
require 'dovado/router/info/operator'
require 'dovado/router/info/operator/telia'

require 'dovado/router/internet'

require 'dovado/router/traffic/amount'
require 'dovado/router/traffic'

require 'dovado/router/sms'
require 'dovado/router/sms/messages'
require 'dovado/router/sms/message'
