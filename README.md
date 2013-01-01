# Halo::Reach::API

Ruby gem for interacting with the Halo:Reach API

* Official: http://www.bungie.net/fanclub/statsapi/Group/Resources/Article.aspx?cid=545064
* Unofficial wiki: http://www.haloreachapi.net/wiki/Available_methods
* You must register with Bungie.net and you can then generate an API key at http://www.bungie.net/Account/reachapikey.aspx

## Requirements

* HTTParty
* JSON
* FakeWeb (testing)
* Mocha (testing)

## Install

```
gem install halo-reach-api
```

## Example

```ruby
require 'halo-reach-api'
=> true
halo_reach_api = Halo::Reach::API.new('xxx') # Where 'xxx' is your Halo:Reach API Key
=> #<Halo::Reach::API:0x1015ec2c8 @token="xxx", @api_url="http://www.bungie.net/api/reach/reachapijson.svc/">
```

Look at the unofficial wiki for complete descriptions of the API calls. 

## FAQ

Q: How do I get an API key?

A: You must register with Bungie.net and you can then generate an API key at http://www.bungie.net/Account/reachapikey.aspx

Q: Dates are funky and not parsed as dates. For example:

```ruby
 { "Credits" : 1000,
 "Description" : "Earn 20 assists today in multiplayer Matchmaking.",
 "ExpirationDate" : "/Date(1290510000000-0800)/",
 "IsWeeklyChallenge" : false,
 "Name" : "Pass the Rock"
 },
```
  
A: Yes they are funky. Yes. They. Are. You can now parse them out with the Halo::Reach::Util class.

```ruby
parsed_time, parsed_timezone = Halo::Reach::Util::parse_timestamp(api_timestamp)
```

## Contributing to halo-reach-api
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2010-2013 David Czarnecki. See LICENSE.txt for further details.

