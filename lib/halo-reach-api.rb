require 'httparty'
require 'json'
require 'cgi'

require 'version'

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
      
      # Create a new Halo::Reach::API class with your token
      def initialize(token, api_url = API_URL)
        @token = token
        @api_url = api_url
      end
      
      # Set a new location for debug output
      def debug(location = $stderr)
        self.class.debug_output(location)
      end

      # Set new HTTP headers
      def set_http_headers(http_headers = {})
        http_headers.merge!(DEFAULT_HEADERS)
        headers(http_headers)
      end
      
      # Set a new default HTTP timeout
      def set_timeout(timeout)
        default_timeout(timeout)
      end
      
      # The "GetGameMetadata" method returns several dictionaries so that resource ids can be translated into their more detailed versions. 
      # For example, this method can be used to associate a medal resource id with its representative medal (say, a killing spree). 
      # 
      # http://www.haloreachapi.net/wiki/GetGameMetadata
      def get_game_metadata
        game_metadata_uri = "game/metadata/#{@token}"        
        self.class.get(@api_url + game_metadata_uri)        
      end
            
      # The "GetCurrentChallenges" method returns the currently active weekly and daily challenges. 
      #
      # http://www.haloreachapi.net/wiki/GetCurrentChallenges
      def get_current_challenges
        current_challenges_uri = "game/challenges/#{@token}"
        self.class.get(@api_url + current_challenges_uri)        
      end
      
      # The "GetGameDetails" method returns detailed information for a given game ID. 
      #
      # http://www.haloreachapi.net/wiki/GetGameDetails
      def get_game_details(game_id)
        get_game_details_uri = "game/details/#{@token}/#{game_id}"
        self.class.get(@api_url + get_game_details_uri)        
      end
      
      # The "GetGameHistory" method returns a players list of games, in chronological reverse over. Returned games is paginated, 
      # and you can specific which game variant, (Invasion, Campaign, for example), or Unknown for all games. 
      #
      # http://www.haloreachapi.net/wiki/GetGameHistory
      def get_game_history(gamertag, variant_class = 'Unknown', page = 0)
        get_game_history_uri = "player/gamehistory/#{@token}/#{URI.escape(gamertag)}/#{variant_class}/#{page}"
        self.class.get(@api_url + get_game_history_uri)        
      end
      
      # Undocumented
      # 
      # http://www.haloreachapi.net/wiki/GetPlayerDetailsWithStatsByMap
      def get_player_details_with_stats_by_map(gamertag)
        get_player_details_with_stats_by_map_uri = "player/details/bymap/#{@token}/#{URI.escape(gamertag)}"
        self.class.get(@api_url + get_player_details_with_stats_by_map_uri)        
      end

      # The "GetPlayerDetailsWithStatsByPlaylist" method Returns detailed aggregate information on a player, including arena information. 
      #
      # http://www.haloreachapi.net/wiki/GetPlayerDetailsWithStatsByPlaylist
      def get_player_details_with_stats_by_playlist(gamertag)
        get_player_details_with_stats_by_playlist_uri = "player/details/byplaylist/#{@token}/#{URI.escape(gamertag)}"
        self.class.get(@api_url + get_player_details_with_stats_by_playlist_uri)        
      end
      
      # The "GetPlayerDetailsWithNoStats" method returns basic information about a player. 
      #
      # http://www.haloreachapi.net/wiki/GetPlayerDetailsWithNoStats
      def get_player_details_with_no_stats(gamertag)
        get_player_details_with_no_stats_uri = "player/details/nostats/#{@token}/#{URI.escape(gamertag)}"
        self.class.get(@api_url + get_player_details_with_no_stats_uri)
      end
      
      # The "GetPlayerFileShare" method returns a listing of files in a player's file share. 
      # 
      # http://www.haloreachapi.net/wiki/GetPlayerFileShare
      def get_player_file_share(gamertag)
        get_player_file_share_uri = "file/share/#{@token}/#{URI.escape(gamertag)}"
        self.class.get(@api_url + get_player_file_share_uri)        
      end
      
      # The "GetFileDetails" method returns the file details for a single file. 
      # 
      # http://www.haloreachapi.net/wiki/GetFileDetails
      def get_file_details(file_id)
        get_file_details_uri = "file/details/#{@token}/#{file_id}"
        self.class.get(@api_url + get_file_details_uri)                
      end
      
      # The "GetPlayerRecentScreenshots" method returns a list of the player's recent screenshots. 
      # 
      # http://www.haloreachapi.net/wiki/GetPlayerRecentScreenshots
      def get_player_recent_screenshots(gamertag)
        get_player_recent_screenshots_uri = "file/screenshots/#{@token}/#{URI.escape(gamertag)}"
        self.class.get(@api_url + get_player_recent_screenshots_uri)        
      end      

      # The "GetPlayerFileSets" method returns a listing of file sets created by the player. 
      # 
      # http://www.haloreachapi.net/wiki/GetPlayerFileSets
      def get_player_file_sets(gamertag)
        get_player_file_sets_uri = "file/sets/#{@token}/#{URI.escape(gamertag)}"
        self.class.get(@api_url + get_player_file_sets_uri)        
      end      

      # The "GetPlayerFileSetFiles" method returns a listing of files in the specified file set. 
      #
      # http://www.haloreachapi.net/wiki/GetPlayerFileSetFiles
      def get_player_file_set_files(gamertag, file_set_id)
        get_player_file_set_files_uri = "file/sets/files/#{@token}/#{URI.escape(gamertag)}/#{file_set_id}"
        self.class.get(@api_url + get_player_file_set_files_uri)        
      end      
      
      # The "GetPlayerRenderedVideos" method returns a listing of rendered videos created by a player. 
      # 
      # http://www.haloreachapi.net/wiki/GetPlayerRenderedVideos
      def get_player_rendered_videos(gamertag, page = 0)
        get_player_rendered_videos_uri = "file/videos/#{@token}/#{URI.escape(gamertag)}/#{page}"
        self.class.get(@api_url + get_player_rendered_videos_uri)        
      end
      
      # The "ReachFileSearch" method returns a listing of files matching the specified criteria. 
      # 
      # http://www.haloreachapi.net/wiki/ReachFileSearch
      def reach_file_search(file_category, map_filter, engine_filter, date_filter, sort_filter, tags, page = 0)
        reach_file_search_uri = "file/search/#{@token}/#{file_category}/#{map_filter}/#{engine_filter}/#{date_filter}/#{sort_filter}/#{page}"
        unless tags.nil?
          reach_file_search_uri += "?tags=#{URI.escape(tags)}"
        end
        
        self.class.get(@api_url + reach_file_search_uri)        
      end
    end
  end
end
