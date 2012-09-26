require 'spec_helper'

describe Halo::Reach::API do
  it 'should allow you to set an API token' do
    halo_reach_api = Halo::Reach::API.new('apikeytoken')

    halo_reach_api.token.should == 'apikeytoken'
  end

  it 'should allow you to set the API url' do
    halo_reach_api = Halo::Reach::API.new('apikeytoken', 'http://some.api.url')

    halo_reach_api.api_url.should == 'http://some.api.url'
  end

  it 'should allow you to set HTTP headers' do
    halo_reach_api = Halo::Reach::API.new('apikeytoken')
    halo_reach_api.expects(:headers).at_least_once

    halo_reach_api.set_http_headers({'Accept' => 'application/json'})
  end

  it 'should allow you to retrieve game metadata' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/game/metadata/XXX',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_game_metadata.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_game_metadata

    halo_reach_api_response['Data']['AllMapsById'].size.should == 30
  end

  it 'should allow you to retrieve current game challenges' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/game/challenges/XXX',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_current_challenges.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_current_challenges

    halo_reach_api_response['Weekly'].size.should == 1
    halo_reach_api_response['Daily'].size.should == 4
  end

  it 'should allow you to retrieve game history' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/player/gamehistory/XXX/MajorNelson/Unknown/0',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_game_history.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_game_history('MajorNelson')

    halo_reach_api_response['RecentGames'].size.should == 25
  end

  it 'should allow you to retrieve game details' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/game/details/XXX/666',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_game_details.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_game_details(666)

    halo_reach_api_response['GameDetails']['GameId'].should == 666
  end

  it 'should allow you to retrieve player details with stats by map' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/player/details/bymap/XXX/foobar',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_details_with_stats_by_map.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_details_with_stats_by_map('foobar')

    halo_reach_api_response['StatisticsByMap'].should_not be_nil
  end

  it 'should allow you to retrieve player details with stats by playlist' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/player/details/byplaylist/XXX/foobar',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_details_with_stats_by_playlist.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_details_with_stats_by_playlist('foobar')

    halo_reach_api_response['StatisticsByPlaylist'].should_not be_nil
  end

  it 'should allow you to retrieve player details with no stats' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/player/details/nostats/XXX/foobar',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_details_with_no_stats.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_details_with_no_stats('foobar')

    halo_reach_api_response['Player']['CampaignProgressCoop'].should == 'None'
  end

  it 'should allow you to retrieve a player file share' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/share/XXX/Gamertag',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_file_share.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_file_share('Gamertag')

    halo_reach_api_response['Files'].size.should == 3
  end

  it 'should allow you to retrieve file details' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/details/XXX/666',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_file_details.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_file_details(666)

    halo_reach_api_response['Files'][0]['DownloadCount'].should == 3
  end

  it 'should allow you to retrieve player recent screenshots' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/screenshots/XXX/Gamertag',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_recent_screenshots.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_recent_screenshots('Gamertag')

    halo_reach_api_response['Files'].size.should == 5
  end

  it 'should allow you to retrieve player file sets' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/sets/XXX/Gamertag',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_file_sets.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_file_sets('Gamertag')

    # FIXME: Need a gamertag with actual file sets
    halo_reach_api_response['FileSets'].size.should == 0
  end

  it 'should allow you to retrieve player file sets with file set ID' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/sets/files/XXX/Gamertag/0',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_file_set_files.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_file_set_files('Gamertag', 0)

    # FIXME: Need a gamertag with actual file sets and files
    halo_reach_api_response['reason'].should == 'Player not found.'
  end

  it 'should allow you to retrieve player rendered videos' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/videos/XXX/Gamertag/0',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'get_player_rendered_videos.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.get_player_rendered_videos('Gamertag', 0)

    # FIXME: Need a gamertag with actual rendered videos
    halo_reach_api_response['Files'].size.should == 0
  end

  it 'should allow you to file search' do
    FakeWeb.register_uri(:get,
                         'http://www.bungie.net/api/reach/reachapijson.svc/file/search/XXX/GameClip/null/null/Week/MostDownloads/0',
                         :body => File.join(File.dirname(__FILE__), 'fakeweb', 'reach_file_search.json'),
                         :content_type => "application/json")

    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api_response = halo_reach_api.reach_file_search('GameClip', 'null', 'null', 'Week', 'MostDownloads', nil, 0)

    halo_reach_api_response['Files'].size.should == 25
  end

  it 'should allow you to set a timeout' do
    halo_reach_api = Halo::Reach::API.new('XXX')
    halo_reach_api.expects(:default_timeout).at_least_once

    halo_reach_api.set_timeout(5)
  end
end