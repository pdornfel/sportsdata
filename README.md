[![Build Status](https://travis-ci.org/miamiruby/sportsdata.png?branch=master)](https://travis-ci.org/miamiruby/sportsdata)

= Sports Data Api

sportsdatainc.com

To configure sports data
/config/initializers/sportsdata.rb

You can access this gem through console
rake console

How to do a single line config in console
```ruby
Sportsdata.configure{|config| config.nfl_api_key = 'moo'}
```

```ruby
Sportsdata.configure do |config|
  config.nfl_api_key    = ENV['SPORTSDATA_NFL_API_KEY']
  config.nhl_api_key    = ENV['SPORTSDATA_NHL_API_KEY']
  config.nba_api_key    = ENV['SPORTSDATA_NBA_API_KEY']
  config.mlb_api_key    = ENV['SPORTSDATA_MLB_API_KEY']
  config.golf_api_key   = ENV['SPORTSDATA_GOLF_API_KEY']
  config.nascar_api_key = ENV['SPORTSDATA_NASCAR_API_KEY']
  config.ncaafb_api_key = ENV['SPORTSDATA_NCAAFB_API_KEY']
  config.ncaamb_api_key = ENV['SPORTSDATA_NCAAMB_API_KEY']
  #API_MODE use 'rt' for production and 't' for testing
  config.api_mode = 'rt'
end
```
== Copyright

Copyright (c) 2013 Paul Kruger, Moises Zaragoza and Aldo Delgado. See LICENSE.txt for further details.
