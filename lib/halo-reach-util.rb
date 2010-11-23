module Halo
  module Reach
    class Util
      def self.parse_timestamp(timestamp = nil)
        # Expected format: '/Date(1284497520000-0700)/'
        # The API returns the date as a UNIX timestamp in milliseconds
        # The "0700" represents the timezone, in this example the U.S. Pacific (GMT-7) timezone
        # (http://www.haloreachapi.net/wiki/Date_time_format)

        if timestamp && (timestamp =~ /^\/Date\((\d+)-(\d+)\)\/$/)
          return [Time.at($1.to_i / 1000).utc, $2]
        else
          raise ArgumentError.new('Invalid timestamp') 
        end
      end
    end
  end
end

