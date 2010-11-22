require 'httparty'
require 'json'

module Halo
  module Reach
    class API
      include HTTParty

      VERSION = '1.0.0'.freeze
      API_URL = 'http://www.bungie.net/api/reach/reachapijson.svc/'
      
      DEFAULT_HEADERS = {
        'User-Agent' => "Halo:Reach API gem #{VERSION}"
      }

      headers(DEFAULT_HEADERS)

      format(:json)

      attr_accessor :api_url
      attr_accessor :token
      
      def initialize(token, api_url = API_URL)
        @token = token
        @api_url = api_url
      end
      
      def debug(location = $stderr)
        self.class.debug_output(location)
      end

      def set_http_headers(http_headers = {})
        http_headers.merge!(DEFAULT_HEADERS)
        headers(http_headers)
      end      
    end
  end
end
