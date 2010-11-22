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
    assert_equal '1.0.0', Halo::Reach::API::VERSION
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
end
