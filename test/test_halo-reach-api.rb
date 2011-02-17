require 'helper'
require 'fakeweb'
require 'mocha'

class TestHaloReachApi < Test::Unit::TestCase
  def setup
    FakeWeb.allow_net_connect = false
  end
  
  def teardown
    FakeWeb.allow_net_connect = true
  end
  
  def test_api_version
    assert_equal '1.0.2', Halo::Reach::API::VERSION
  end
  
  def test_can_set_token
    halo_reach_api = Halo::Reach::API.new('apikeytoken')
    
    assert_equal 'apikeytoken', halo_reach_api.token
  end
  
  def test_can_set_api_url
    halo_reach_api = Halo::Reach::API.new('apikeytoken', 'http://some.api.url')
    
    assert_equal 'http://some.api.url', halo_reach_api.api_url    
  end
  
  def test_can_set_http_headers
    halo_reach_api = Halo::Reach::API.new('apikeytoken')
    halo_reach_api.expects(:headers).at_least_once
    
    halo_reach_api.set_http_headers({'Accept' => 'application/json'})
  end
  
  def test_get_game_metadata
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/game/metadata/XXX', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_game_metadata.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_game_metadata    
    
    assert_equal 30, halo_reach_api_response['Data']['AllMapsById'].size
  end

  def test_get_current_challenges
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/game/challenges/XXX', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_current_challenges.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_current_challenges    
    
    assert_equal 1, halo_reach_api_response['Weekly'].size
    assert_equal 4, halo_reach_api_response['Daily'].size
  end
  
  def test_get_game_history
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/player/gamehistory/XXX/MajorNelson/Unknown/0', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_game_history.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_game_history('MajorNelson')
    
    assert_equal 25, halo_reach_api_response['RecentGames'].size
  end
  
  def test_get_game_details
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/game/details/XXX/666', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_game_details.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_game_details(666)
    
    assert_equal 666, halo_reach_api_response['GameDetails']['GameId']
  end  

  def test_get_player_details_with_stats_by_map
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/player/details/bymap/XXX/foobar', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_details_with_stats_by_map.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_details_with_stats_by_map('foobar')
    
    assert_not_nil halo_reach_api_response['StatisticsByMap']
  end  

  def test_get_player_details_with_stats_by_playlist
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/player/details/byplaylist/XXX/foobar', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_details_with_stats_by_map.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_details_with_stats_by_map('foobar')
    
    assert_not_nil halo_reach_api_response['StatisticsByPlaylist']
  end  

  def test_get_player_details_with_no_stats
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/player/details/nostats/XXX/foobar', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_details_with_no_stats.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_details_with_no_stats('foobar')
    
    assert_equal 'None', halo_reach_api_response['Player']['CampaignProgressCoop']
  end  

  def test_get_player_file_share
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/share/XXX/Gamertag', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_file_share.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_file_share('Gamertag')
    
    assert_equal 3, halo_reach_api_response['Files'].size
  end

  def test_get_file_details
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/details/XXX/666', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_file_details.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_file_details(666)
    
    assert_equal 3, halo_reach_api_response['Files'][0]['DownloadCount']
  end   

  def test_get_player_recent_screenshots
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/screenshots/XXX/Gamertag', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_recent_screenshots.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_recent_screenshots('Gamertag')
    
    assert_equal 5, halo_reach_api_response['Files'].size
  end

  def test_get_player_file_sets
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/sets/XXX/Gamertag', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_file_sets.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_file_sets('Gamertag')
    
    # FIXME: Need a gamertag with actual file sets
    assert_equal 0, halo_reach_api_response['FileSets'].size
  end

  def test_get_player_file_sets
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/sets/files/XXX/Gamertag/0', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_file_set_files.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_file_set_files('Gamertag', 0)
    
    # FIXME: Need a gamertag with actual file sets and files
    assert_equal 'Player not found.', halo_reach_api_response['reason']
  end

  def test_get_player_rendered_videos
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/videos/XXX/Gamertag/0', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_rendered_videos.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_rendered_videos('Gamertag', 0)
    
    # FIXME: Need a gamertag with actual rendered videos
    assert_equal 0, halo_reach_api_response['Files'].size
  end

  def test_reach_file_search
    FakeWeb.register_uri(:get, 
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/search/XXX/GameClip/null/null/Week/MostDownloads/0', 
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'reach_file_search.json'), 
                         :content_type => "application/json")
                         
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.reach_file_search('GameClip', 'null', 'null', 'Week', 'MostDownloads', nil, 0)
    
    assert_equal 25, halo_reach_api_response['Files'].size
  end

  def test_can_set_timeout
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api.expects(:default_timeout).at_least_once
    
    halo_reach_api.set_timeout(5)
  end
end
