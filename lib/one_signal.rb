require "one_signal/version"
require "one_signal/config"
require "one_signal/interface"

module OneSignal
  class << self

  	def send_to_specific(user_ids, title, content)
  		Interface.new(configuration).send_to_specific(user_ids, title, content)
  	end

  	def send_notification(params)
  		Interface.new(configuration).send_notification(params)
  	end
  end
end
