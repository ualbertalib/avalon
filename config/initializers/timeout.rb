# Lengthen timeout when executing REST API calls via rubyhorn (to Matterhorn) overriding
# https://github.com/avalonmediasystem/rubyhorn/blob/avalon-r6/lib/rubyhorn/rest_client/common.rb#L8
# Todo: not needed in Avalon v7.1
module Rubyhorn::RestClient
  module Common

    def connect
      super.connect
      @client.open_timeout =  ENV['AVALON_MATTERHORN_TIMEOUT'].to_i if ENV['AVALON_MATTERHORN_TIMEOUT']
    end
  end
end