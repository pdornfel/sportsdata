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
      all_teams.each { |conference|
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

    def self.games(options = {:years => [Date.today.year-1, Date.today.year, Date.today.year+1], :seasons => [:pre, :reg, :pst]})
      games = []
      options[:seasons].each{|season|
        sleep(2)
        options[:years].each{|year|
          response = self.get_raw(games_url(:year => year, :season => season))
          if response['season']
            all_games = response['season'].try(:[], 'week')
            all_games ||= []
            all_games.each { |week|
              if week['game'].class.name == 'Array'
                week['game'].each { |game|
                  game_record = {}
                  game_record[:week]                = week['week']
                  if game.class.name == 'Hash'
                    game_record[:sports_data_guid]  = game['id']
                    game_record[:scheduled_at]      = game['scheduled']
                    game_record[:home_team_guid]    = game['home']
                    game_record[:away_team_guid]    = game['away']
                    game_record[:status]            = game['status']
                  else
                    game_record[:sports_data_guid]  = game[1]['id']
                    game_record[:scheduled_at]      = game[1]['scheduled']
                    game_record[:home_team_guid]    = game[1]['home']
                    game_record[:away_team_guid]    = game[1]['away']
                    game_record[:status]            = game[1]['status']
                  end
                  games.append(game_record)
                }
              else
                if week['game']
                  week['game'].each { |game|
                    game_record = {}
                    game_record[:week]                = week['week']
                    if game.class.name == 'Hash'
                      game_record[:sports_data_guid]  = game['id']
                      game_record[:scheduled_at]      = game['scheduled']
                      game_record[:home_team_guid]    = game['home']
                      game_record[:away_team_guid]    = game['away']
                      game_record[:status]            = game['status']
                    else
                      game_record[:sports_data_guid]  = game[1]['id']
                      game_record[:scheduled_at]      = game[1]['scheduled']
                      game_record[:home_team_guid]    = game[1]['home']
                      game_record[:away_team_guid]    = game[1]['away']
                      game_record[:status]            = game[1]['status']
                    end
                    games.append(game_record)
                  }
                end
              end
              }
          end
        }
      }
      games
    end

    def self.game_statistics(options = {:year => 2013, :season => 'REG', :week => 1, :away_team => 'BAL', :home_team => 'DEN'})
      statistics = []
      response = self.get_raw(game_statistics_url(:year => options[:year], :season => options[:season], :week => options[:week], :away_team => options[:away_team], :home_team => options[:home_team]))
      statistics_record = {}
      statistics_record[:sports_data_guid]       = response['game']['id']
      statistics_record[:scheduled_at]           = response['game']['scheduled']
      statistics_record[:sports_data_home_guid]  = response['game']['home']
      statistics_record[:sports_data_away_guid]  = response['game']['away']
      statistics_record[:status]                 = response['game']['status']
      statistics_record[:params]                 = response
      statistics.append(statistics_record)
      statistics
    end

    def self.players(options = {})
      players = []
      teams = Sportsdata.nfl.teams
      teams.each{|team|
        sleep(2)
        response = self.get_raw(players_url(:team_abbr => team[:sports_data_guid]))
        all_players = response['team'].try(:[], 'player')
        all_players ||= []
        all_players.each { |player|
          player_record = {}
          player_record[:team_guid]         = team[:sports_data_guid]
          player_record[:sports_data_guid]  = player['id']
          player_record[:full_name]         = player['name_full']
          player_record[:first_name]        = player['name_first']
          player_record[:last_name]         = player['name_last']
          player_record[:abbr_name]         = player['name_abbr']
          player_record[:birthday]          = player['birthdate']
          player_record[:birth_place]       = player['birth_place']
          player_record[:high_school]       = player['high_school']
          player_record[:height]            = player['height']
          player_record[:weight]            = player['weight']
          player_record[:college]           = player['college']
          player_record[:position]          = player['position']
          player_record[:jersey_number]     = player['jersey_number']
          player_record[:status]            = player['status']
          player_record[:salary]            = player['salary']
          player_record[:experience]        = player['experience']
          player_record[:draft_pick]        = player['draft_pick']
          player_record[:draft_round]       = player['draft_round']
          player_record[:draft_team]        = player['draft_team']
          players.append(player_record)
        }
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

    def self.game_statistics_url(options = {})
      "#{options[:year]}/#{options[:season]}/#{options[:week]}/#{options[:away_team]}/#{options[:home_team]}/statistics.xml"
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
