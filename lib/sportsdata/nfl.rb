module Sportsdata
  module Nfl
    class Exception < ::Exception
    end

    attr_accessor :api_key, :api_mode

    def self.api_key
      Sportsdata.nfl_api_key
    end

    def self.api_mode
      Sportsdata.api_mode
    end

    def self.venues(options = {})
      venues = []
      response = self.get_raw(self.venues_url)
      all_venues = response['league'].try(:[], 'conference')
      all_venues ||= []
      all_venues.each { |conference|
        conference['division'].each { |division|
          division['team'].each { |team|
            venue_record = {}
            venue_record[:sports_data_guid] = team['venue']['id']
            venue_record[:name]             = team['venue']['name']
            venue_record[:address]          = team['venue']['address']
            venue_record[:city]             = team['venue']['city']
            venue_record[:state]            = team['venue']['state']
            venue_record[:zip]              = team['venue']['zip']
            venue_record[:capacity]         = team['venue']['capacity']
            venue_record[:surface]          = team['venue']['surface']
            venue_record[:venue_type]       = team['venue']['type']
            venues.append(venue_record)
          }
        }
      }
      venues
    end

    def self.teams(options = {})
      teams = []
      response = self.get_raw(self.teams_url)
      all_teams = response['league'].try(:[], 'conference')
      all_teams ||= []
      ap all_teams.each { |conference|
        conference['division'].each { |division|
          division['team'].each { |team|
            team_record = {}
            team_record[:league_abbr]       = conference['name']
            team_record[:division]          = division['name']
            team_record[:sports_data_guid]  = team['id']
            team_record[:abbr]              = team['id']
            team_record[:name]              = team['name']
            team_record[:city]              = team['market']
            teams.append(team_record)
          }
        }
      }
      teams
    end

    #fetch last year, this year and next year
    # Their are three season options (PRE, REG, PST)
    def self.games(options = {:year => Date.today.year, :season => 'REG'})
      games = []
      response = self.get_raw(games_url(:year => 2012))
      #games_url(:year => 2012)
      #games_url(:year => 2012)
      all_games = response['season'].try(:[], 'week')
      all_games ||= []
      all_games.each { |week|
        week['game'].each { |game|
          game_record = {}
          game_record[:week]              = week['week']
          game_record[:sports_data_guid]  = game['guid']
          game_record[:scheduled_at]      = game['scheduled']
          game_record[:home_team_guid]    = game['home']
          game_record[:away_team_guid]    = game['away']
          game_record[:status]            = game['status']

          #game_record[:wind_speed]           = game['weather']['wind']['speed']
          #game_record[:wind_direction]       = game['weather']['wind']['direction']

          #game_record[:weather_temperature]  = game['weather']['temperature']
          #game_record[:weather_condition]    = game['weather']['condition']
          #game_record[:weather_humidity]     = game['weather']['humidity']

          #game_record[:broadcast_network]    = game['broadcast']['network']
          #game_record[:broadcast_satellite]  = game['broadcast']['satellite']
          #game_record[:broadcast_internet]   = game['broadcast']['internet']
          #game_record[:broadcast_cable]      = game['broadcast']['cable']
          games.append(game_record)
        }
      }
      games
    end

    def self.players(options = {})
      players = []
      response = self.get_raw(players_url(:team_abbr => 'MIA'))
      all_players = response['team'].try(:[], 'player')
      all_players ||= []
      all_players.each { |player|
        player_record = {}
        player_record[:sports_data_guid] = player['id']
        player_record[:full_name]        = player['name_full']
        player_record[:first_name]       = player['name_first']
        player_record[:last_name]        = player['name_last']
        player_record[:abbr_name]        = player['name_abbr']
        player_record[:birthday]         = player['birthdate']
        player_record[:birth_place]      = player['birth_place']
        player_record[:high_school]      = player['high_school']
        player_record[:height]           = player['height']
        player_record[:weight]           = player['weight']
        player_record[:college]          = player['college']
        player_record[:position]         = player['position']
        player_record[:jersey_number]    = player['jersey_number']
        player_record[:status]           = player['status']
        player_record[:salary]           = player['salary']
        player_record[:experience]       = player['experience']
        player_record[:draft_pick]       = player['draft_pick']
        player_record[:draft_round]      = player['draft_round']
        player_record[:draft_team]       = player['draft_team']
        players.append(player_record)
      }
      players
    end

    private
    def self.version
      "1"
    end

    def self.base_url
      "http://api.sportsdatallc.org/nfl-#{self.api_mode}#{self.version}"
    end

    def self.venues_url
      "teams/hierarchy.xml"
    end

    def self.teams_url
      "teams/hierarchy.xml"
    end

    def self.games_url(options = {})
      "#{options[:year]}/#{options[:season]}/schedule.xml"
    end

    def self.players_url(options = {})
      "teams/#{options[:team_abbr]}/roster.xml"
    end

    def self.api
      Faraday.new self.base_url do |a|
        a.response :xml, :content_type => /\bxml$/
        a.adapter Faraday.default_adapter
      end
    end

    def self.get_raw(url)
      begin
        response = self.api.get(url, { :api_key => self.api_key })
        return response.body
      rescue Faraday::Error::TimeoutError => timeout
        raise Sportsdata::Exception, 'Sportsdata Timeout Error'
      rescue Exception => e
        message = if e.response.headers.key? :x_server_error
                    JSON.parse(e.response.headers[:x_server_error], { symbolize_names: true })[:message]
                  elsif e.response.headers.key? :x_mashery_error_code
                    e.response.headers[:x_mashery_error_code]
                  else
                    "The server did not specify a message"
                  end
        raise Sportsdata::Exception, message
      end
    end

    def self.errors
      @errors = {
        0 => "OK",
        1 => "No Response"
      }
    end
  end
end
