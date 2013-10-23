module Sportsdata
  module Nba
    class Exception < ::Exception
    end
    class Venue < OpenStruct
    end
    class Player < OpenStruct
    end
    class Team < OpenStruct
    end
    class Schedule < OpenStruct
    end
    class Game < OpenStruct
    end

    #include HTTParty
    attr_accessor :api_key, :api_mode
    #default_timeout 15

    def self.api_key
      Sportsdata.nba_api_key
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
            venue_record[:guid]       = team['venue']['id']
            venue_record[:name]       = team['venue']['name']
            venue_record[:capacity]   = team['venue']['capacity']
            venue_record[:address]    = team['venue']['address']
            venue_record[:city]       = team['venue']['city']
            venue_record[:state]      = team['venue']['state']
            venue_record[:zip]        = team['venue']['zip']
            venues.append(Venue.new(venue_record))
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
      all_teams.each { |conference|
        team_record = {}
        team_record[:league_abbr] = conference['name']
        conference['division'].each { |division|
          team_record[:division] = division['name']
          division['team'].each { |team|
            team_record[:guid]  = team['id']
            team_record[:name]  = team['name']
            team_record[:city]  = team['market']
            team_record[:abbr]  = team['alias']
            teams.append(Team.new(team_record))
          }
        }
      }
      teams
    end

    #fetch last year, this year and next year
    # Their are three season options (PRE, REG, PST)
    def self.games(options = {:year => Date.today.year, :season => 'REG'})
      games = []
      response = self.get_raw(games_url(:year => 2013, :season => 'REG'))
      #games_url(:year => 2012)
      #games_url(:year => 2012)
      all_games = response['league'].try(:[], 'season_schedule')
      all_games ||= []
      all_games['games']['game'].each { |game|
        game_record = {}
        game_record[:guid]            = game['id']
        game_record[:status]          = game['status']
        game_record[:coverage]        = game['coverage']
        game_record[:home_team_guid]  = game['home_team']
        game_record[:away_team_guid]  = game['away_team']
        game_record[:scheduled]       = game['scheduled']
        game_record[:home_team_name]  = game['home']['name']
        game_record[:home_team_abbr]  = game['home']['alias']
        game_record[:away_team_name]  = game['away']['name']
        game_record[:away_team_abbr]  = game['away']['alias']
        games.append(Game.new(game_record))
      }
      games
    end

    def self.players(options = {})
      players = []
      response = self.get_raw(players_url(:team_guid => '583ecd4f-fb46-11e1-82cb-f4ce4684ea4c'))
      all_players = response['team'].try(:[], 'players')
      all_players ||= []
      all_players.each { |player|
        player_record = {}
        player_record[:guid]            = player['id']
        player_record[:status]          = player['status']
        player_record[:full_name]       = player['full_name']
        player_record[:first_name]      = player['first_name']
        player_record[:last_name]       = player['last_name']
        player_record[:abbr_name]       = player['abbr_name']
        player_record[:height]          = player['height']
        player_record[:weight]          = player['weight']
        player_record[:position]        = player['position']
        player_record[:primary_position]= player['primary_position']
        player_record[:jersey_number]   = player['jersey_number']
        player_record[:experience]      = player['experience']
        player_record[:college]         = player['college']
        player_record[:birth_place]     = player['birth_place']
        player_record[:birthdate]       = player['birthdate']
        player_record[:updated]         = player['updated']

        player_record[:draft_team_guid] = player['draft']['team_id']
        player_record[:draft_year]      = player['draft']['year']
        player_record[:draft_round]     = player['draft']['round']
        player_record[:draft_pick]      = player['draft']['pick']

        players.append(Player.new(player_record))
      }
      players
    end

    private
    def self.version
      "3"
    end

    def self.base_url
      "http://api.sportsdatallc.org/nba-#{self.api_mode}#{self.version}"
    end

    def self.venues_url
      "league/hierarchy.xml"
    end

    def self.teams_url
      "league/hierarchy.xml"
    end

    def self.games_url(options = {})
      "games/#{options[:year]}/#{options[:season]}/schedule.xml"
    end

    def self.players_url(options = {})
      "teams/#{options[:team_guid]}/profile.xml"
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
