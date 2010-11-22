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
end
