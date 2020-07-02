# Lengthen timeout when executing ingest REST API calls via rubyhorn gem (to the Matterhorn service) overriding Rubyhorn::RestClient::Common `connect`
# https://github.com/avalonmediasystem/rubyhorn/blob/avalon-r6/lib/rubyhorn/rest_client/common.rb#L8
# Note: using `super.connect` to leave the origin `connect` as is. The reasoning:
# a) `login` timeout shouldn't be extended as it opens a denial of service opportunity,
# b) if `login` fails the active job is retried (https://github.com/avalonmediasystem/avalon/blob/v6.5.0/app/jobs/active_encode_job.rb#L40), and
# c) the timeouts occur in `addMediaPackage and addMediaPackageUrl` (https://github.com/avalonmediasystem/rubyhorn/blob/master/lib/rubyhorn/rest_client/ingest.rb#L22-L40) and not the `login` method
# Todo: not needed in Avalon v7.1
module Rubyhorn::RestClient
  module Common

    def connect
      super.connect
      @client.open_timeout =  ENV['AVALON_MATTERHORN_TIMEOUT'].to_i if ENV['AVALON_MATTERHORN_TIMEOUT']
    end
  end
end
