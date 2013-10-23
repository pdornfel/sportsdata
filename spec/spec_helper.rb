$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'yaml'
require 'awesome_print'
require 'ruby-debug'
require 'sportsdata'
require 'webmock/rspec'
require 'vcr'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

dev = File.join('config.yml')
YAML.load(File.open(dev)).each do |key, value|
  ENV[key.to_s] = value
end if File.exists?(dev)

RSpec.configure do |config|
  dev = File.join('config.yml')
  YAML.load(File.open(dev)).each do |key, value|
    ENV[key.to_s] = value
  end if File.exists?(dev)
end

Sportsdata.configure do |config|
  config.nfl_api_key = ENV['SPORTSDATA_NFL_API_KEY']
  config.nhl_api_key = ENV['SPORTSDATA_NHL_API_KEY']
  config.nba_api_key = ENV['SPORTSDATA_NBA_API_KEY']
  config.mlb_api_key = ENV['SPORTSDATA_MLB_API_KEY']
  config.ncaafb_api_key = ENV['SPORTSDATA_NCAAFB_API_KEY']
  config.ncaamb_api_key = ENV['SPORTSDATA_NCAAMB_API_KEY']
  config.nascar_api_key = ENV['SPORTSDATA_NASCAR_API_KEY']
  config.golf_api_key = ENV['SPORTSDATA_GOLF_API_KEY']
  config.api_mode = ENV['SPORTSDATA_API_MODE']
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.preserve_exact_body_bytes { true }
  c.configure_rspec_metadata!
  ##
  # Filter the real API key so that it does not make its way into the VCR cassette
  #dev = File.join('config.yml')
  #YAML.load(File.open(dev)).each do |key, value|
  #  c.filter_sensitive_data("<#{key}>")  { value }
  #end if File.exists?(dev)
end
