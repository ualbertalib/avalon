# Lengthen timeout when executing ingest REST API calls via rubyhorn gem (to the Matterhorn service) overriding:
# * Rubyhorn::RestClient::Common `connect`
#   * https://github.com/avalonmediasystem/rubyhorn/blob/avalon-r6/lib/rubyhorn/rest_client/common.rb#L8
# * Rubyhorn::MatterhornClient `initialize` 
#   * https://github.com/avalonmediasystem/rubyhorn/blob/avalon-r6/lib/rubyhorn/matterhorn_client.rb#24T
# To test if timeout changed: from rails console - Rubyhorn.init; Rubyhorn.client;
# Timeouts affected mostly the `ingest/addTrack` and `ingest\addMediaPackage` 
#   *https://github.com/avalonmediasystem/rubyhorn/blob/avalon-r6/lib/rubyhorn/rest_client/ingest.rb
# Todo: not needed in Avalon v7.1

# Override initialize otherwise the local `connect` is not called; the `connect` in the rubyhorn gem is called
module Rubyhorn
  class MatterhornClient
    def initialize options = {}
      @config = options
      connect
    end
  end
end

# Extend timeout via the env variable, both open_timeout and read_timeout
module Rubyhorn::RestClient
  module Common
    def connect
      timeout = ENV['AVALON_MATTERHORN_TIMEOUT'] || "60"
      @client = RestClient::Resource.new(config[:url], headers: {'X-REQUESTED-AUTH'=>'Digest'}, timeout: timeout.to_i)
      login
    end
  end
end
