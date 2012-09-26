require 'rspec'
require 'fakeweb'
require 'halo-reach-api'
require 'halo-reach-util'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_framework = :mocha

  config.before(:each) do
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
  end

  config.after(:each) do
    FakeWeb.allow_net_connect = true
  end
end
