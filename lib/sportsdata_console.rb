require 'rubygems'
require 'awesome_print'
require 'sportsdata'
require 'debugger'

Sportsdata.configure do |config|
  config.nfl_api_key    = ENV['NFL_API_KEY']
  config.nhl_api_key    = ENV['NHL_API_KEY']
  config.nba_api_key    = ENV['NBA_API_KEY']
  config.mlb_api_key    = ENV['MLB_API_KEY']
  config.nascar_api_key = ENV['NASCAR_API_KEY']
  config.golf_api_key   = ENV['GOLF_API_KEY']
  config.ncaafb_api_key = ENV['NCAAFB_API_KEY']
  config.ncaamb_api_key = ENV['NCAAMB_API_KEY']
  #API_MODE use 'rt' for production and 't' for testing
  config.api_mode = 't'
end

