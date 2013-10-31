module Sportsdata
  module Nba
    class Exception < ::Exception
    end

    attr_accessor :api_key, :api_mode

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
            venue_record[:sports_data_guid] = team['venue']['id']
            venue_record[:name]             = team['venue']['name']
            venue_record[:capacity]         = team['venue']['capacity']
            venue_record[:address]          = team['venue']['address']
            venue_record[:city]             = team['venue']['city']
            venue_record[:state]            = team['venue']['state']
            venue_record[:zip]              = team['venue']['zip']
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
      all_teams.each { |conference|
        conference['division'].each { |division|
          division['team'].each { |team|
            team_record = {}
            team_record[:league_abbr]       = conference['name']
            team_record[:division]          = division['name']
            team_record[:sports_data_guid]  = team['id']
            team_record[:name]              = team['name']
            team_record[:city]              = team['market']
            team_record[:abbr]              = team['alias']
            teams.append(team_record)
          }
        }
      }
      teams
    end

    def self.games(options = {:years => [Date.today.year-1, Date.today.year, Date.today.year+1], :seasons => ['pre', 'reg', 'pst']})
      games = []
      options[:seasons].each{|season|
        sleep(2)
        options[:years].each{|year|
          response = self.get_raw(games_url(:year => year, :season => season))
          if response['league']
            all_games = response['league'].try(:[], 'season_schedule')
            all_games ||= []
            if all_games['games'] && all_games['games']['game']
              all_games['games']['game'].each { |game|
                game_record = {}
                game_record[:sports_data_guid]  = game['id']
                game_record[:status]            = game['status']
                game_record[:coverage]          = game['coverage']
                game_record[:home_team_guid]    = game['home_team']
                game_record[:away_team_guid]    = game['away_team']
                game_record[:scheduled_at]      = game['scheduled']
                game_record[:home_team_name]    = game['home']['name']
                game_record[:home_team_abbr]    = game['home']['alias']
                game_record[:away_team_name]    = game['away']['name']
                game_record[:away_team_abbr]    = game['away']['alias']
                games.append(game_record)
              }
            end
          end
        }
      }
      games
    end

    def self.players(options = {})
      players = []
      teams = Sportsdata.nba.teams
      teams.each{|team|
        sleep(2)
        response = self.get_raw(players_url(:team_guid => team[:sports_data_guid]))
        all_players = response['team'].try(:[], 'players')
        all_players ||= []
        if all_players
          all_players.each { |player|
            player[1].each{|player_array|
              player_record = {}
              player_record[:team_guid]         = team[:sports_data_guid]
              player_record[:sports_data_guid]  = player_array['id']
              player_record[:status]            = player_array['status']
              player_record[:full_name]         = player_array['full_name']
              player_record[:first_name]        = player_array['first_name']
              player_record[:last_name]         = player_array['last_name']
              player_record[:abbr_name]         = player_array['abbr_name']
              player_record[:height]            = player_array['height']
              player_record[:weight]            = player_array['weight']
              player_record[:position]          = player_array['position']
              player_record[:primary_position]  = player_array['primary_position']
              player_record[:jersey_number]     = player_array['jersey_number']
              player_record[:experience]        = player_array['experience']
              player_record[:college]           = player_array['college']
              player_record[:birth_place]       = player_array['birth_place']
              player_record[:birthday]          = player_array['birthdate']
              player_record[:updated_at]        = player_array['updated']

              if player_array['draft'] && player_array['draft']['team_id']
                player_record[:draft_team_guid]   = player_array['draft']['team_id']
                player_record[:draft_year]        = player_array['draft']['year']
                player_record[:draft_round]       = player_array['draft']['round']
                player_record[:draft_pick]        = player_array['draft']['pick']
              end
              players.append(player_record)
            }
          }
        end
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
