require 'httparty'
require 'json'
require 'cgi'

require 'halo-reach-api-version'

module Halo
  module Reach
    class API
      include HTTParty
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
      
      def set_timeout(timeout)
        default_timeout(timeout)
      end
      
      def get_game_metadata
        game_metadata_uri = "game/metadata/#{@token}"        
        self.class.get(@api_url + game_metadata_uri)        
      end
      
      def get_current_challenges
        current_challenges_uri = "game/challenges/#{@token}"
        self.class.get(@api_url + current_challenges_uri)        
      end
      
      def get_game_details(game_id)
        get_game_details_uri = "game/details/#{@token}/#{game_id}"
        self.class.get(@api_url + get_game_details_uri)        
      end
      
      def get_game_history(gamertag, variant_class = 'Unknown', page = 0)
        get_game_history_uri = "player/gamehistory/#{@token}/#{CGI.escape(gamertag)}/#{variant_class}/#{page}"
        self.class.get(@api_url + get_game_history_uri)        
      end
      
      def get_player_details_with_stats_by_map(gamertag)
        get_player_details_with_stats_by_map_uri = "player/details/bymap/#{@token}/#{CGI.escape(gamertag)}"
        self.class.get(@api_url + get_player_details_with_stats_by_map_uri)        
      end

      def get_player_details_with_stats_by_playlist(gamertag)
        get_player_details_with_stats_by_playlist_uri = "player/details/byplaylist/#{@token}/#{CGI.escape(gamertag)}"
        self.class.get(@api_url + get_player_details_with_stats_by_playlist_uri)        
      end
      
      def get_player_details_with_no_stats(gamertag)
        get_player_details_with_no_stats_uri = "player/details/nostats/#{@token}/#{CGI.escape(gamertag)}"
        self.class.get(@api_url + get_player_details_with_no_stats_uri)        
      end
      
      def get_player_file_share(gamertag)
        get_player_file_share_uri = "file/share/#{@token}/#{CGI.escape(gamertag)}"
        self.class.get(@api_url + get_player_file_share_uri)        
      end
      
      def get_file_details(file_id)
        get_file_details_uri = "file/details/#{@token}/#{file_id}"
        self.class.get(@api_url + get_file_details_uri)                
      end
      
      def get_player_recent_screenshots(gamertag)
        get_player_recent_screenshots_uri = "file/screenshots/#{@token}/#{CGI.escape(gamertag)}"
        self.class.get(@api_url + get_player_recent_screenshots_uri)        
      end      

      def get_player_file_sets(gamertag)
        get_player_file_sets_uri = "file/sets/#{@token}/#{CGI.escape(gamertag)}"
        self.class.get(@api_url + get_player_file_sets_uri)        
      end      

      def get_player_file_set_files(gamertag, file_set_id)
        get_player_file_set_files_uri = "file/sets/files/#{@token}/#{CGI.escape(gamertag)}/#{file_set_id}"
        self.class.get(@api_url + get_player_file_set_files_uri)        
      end      

      def get_player_rendered_videos(gamertag, page = 0)
        get_player_rendered_videos_uri = "file/videos/#{@token}/#{CGI.escape(gamertag)}/#{page}"
        self.class.get(@api_url + get_player_rendered_videos_uri)        
      end

      def reach_file_search(file_category, map_filter, engine_filter, date_filter, sort_filter, tags, page = 0)
        reach_file_search_uri = "file/search/#{@token}/#{file_category}/#{map_filter}/#{engine_filter}/#{date_filter}/#{sort_filter}/#{page}"
        unless tags.nil?
          reach_file_search_uri += "?tags=#{CGI.escape(tags)}"
        end
        
        self.class.get(@api_url + reach_file_search_uri)        
      end
    end
  end
end
