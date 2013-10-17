[![Build Status](https://travis-ci.org/miamiruby/sportsdata.png?branch=master)](https://travis-ci.org/miamiruby/sportsdata)

= Sports Data Api

sportsdatainc.com

To configure sports data
/config/initializers/sportsdata.rb

```ruby
Sportsdata.configure do |config|
  config.nfl_api_key    = ENV['NFL_API_KEY']
  config.nhl_api_key    = ENV['NHL_API_KEY']
  config.nba_api_key    = ENV['NBA_API_KEY']
  config.mlb_api_key    = ENV['MLB_API_KEY']
  config.ncaafb_api_key = ENV['NCAAFB_API_KEY']
  config.ncaamb_api_key = ENV['NCAAMB_API_KEY']
  #API_MODE use 'rt' for production and 't' for testing
  config.api_mode = 'rt'
end
```
== Copyright

Copyright (c) 2013 Paul Kruger and Aldo Delgado. See LICENSE.txt for further details.
