require 'net/http'

# Lengthen timeout in Net::HTTP
module Net
    class HTTP
    alias old_initialize initialize

        def initialize(*args)
            old_initialize(*args)
            @read_timeout = ENV['AVALON_NET_HTTP_READ_TIMEOUT'].to_i if ENV['AVALON_NET_HTTP_READ_TIMEOUT']
        end
    end
end