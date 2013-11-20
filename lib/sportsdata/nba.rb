module Sportsdata
  module Nba
    include Request
    class Exception < ::Exception
    end

    attr_accessor :api_key, :api_mode

    #request methods
    def self.api_key
      Sportsdata.nba_api_key
    end

    def self.api_mode
      Sportsdata.api_mode
    end

    def self.version
      "3"
    end

    def self.name
      "nba"
    end

    def self.game_statuses
      [
        ["scheduled" => "The game is scheduled to occur."],
        ["inprogress" => "The game is in progress."],
        ["halftime" => "The game is currently at halftime."],
        ["complete" => "The game is over, but stat validation is not complete."],
        ["closed" => "The game is over and the stats have been validated."],
        ["cancelled" => "The game has been cancelled."],
        ["delayed" => "The start of the game is currently delayed or the game has gone from in progress to delayed for some reason."],
        ["postponed" => "The game has been postponed, to be made up at another day and time."],
        ["time-tbd" => "The game has been scheduled, but a time has yet to be announced."],
        ["unnecessary" => "The series game was scheduled to occur, but will not take place due to one team clinching the series early."]
      ]
    end

    def self.player_primary_positions
      [
        ["C"],
        ["C-F"],
        ["F"],
        ["F-C"],
        ["F-G"],
        ["G"],
        ["G-F"],
        ["NA"],
        ["PF"],
        ["PG"],
        ["SF"],
        ["SG"]
      ]
    end

    def self.player_injury_statuses
      [
        ["Unknown"],
        ["Day To Day"],
        ["Out"],
        ["Out For Season"],
        ["Out Indefinitely"]
      ]
    end

    def self.game_statistics
      [
        ["Minutes Played"],
        ["Plus/Minus"],
        ["Assists"],
        ["Assist to Turnover Ratio"],
        ["Blocked Attempts"],
        ["Blocked Shots"],
        ["Defensive Rebounds"],
        ["Field Goal Attempts"],
        ["Field Goal Percentage"],
        ["Field Goals Made"],
        ["Flagrant Fouls"],
        ["Free Throw Attempts"],
        ["Free Throw Percentage"],
        ["Free Throws Made"],
        ["Offensive Rebounds"],
        ["Personal Fouls"],
        ["Points"],
        ["Rebounds"],
        ["Steals"],
        ["Technical Fouls"],
        ["Three Point Attempts"],
        ["Three Point Percentage"],
        ["Three Points Made"],
        ["Turnovers"],
        ["Two Point Attempts"],
        ["Two Point Percentage"],
        ["Two Points Made"]
      ]
    end

    def self.player_statuses
      [
        ["ACT" => "Active"],
        ["IR" => "Injured reserve"],
        ["M-LEAGUE" => "Sent to minor league team"],
        ["D-LEAGUE" => "The player is on the team’s development league roster"],
        ["NWT" => "Not with team"],
        ["SUS" => "Suspended"]
      ]
    end

    def self.event_types
      [
        ["clearpathfoul"],
        ["defensivethreeseconds"],
        ["delay"],
        ["ejection"],
        ["endperiod"],
        ["flagrantone"],
        ["flagranttwo"],
        ["freethrow"],
        ["jumpball"],
        ["kickball"],
        ["offensivefoul"],
        ["officialtimeout"],
        ["opentip"],
        ["personalfoul"],
        ["possession"],
        ["rebound"],
        ["review"],
        ["shootingfoul"],
        ["teamtimeout"],
        ["technicalfoul"],
        ["threepointmade"],
        ["threepointmiss"],
        ["turnover"],
        ["tvtimeout"],
        ["twopointmade"],
        ["twopointmiss"],
        ["warning"]
      ]
    end

    def self.venues(options = {})
      venues = []
      response = self.get(self.venues_url)
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
            venue_record[:params]           = team
            venues.append(venue_record)
          }
        }
      }
      venues
    end

    def self.teams(options = {})
      teams = []
      response = self.get(self.teams_url)
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
            team_record[:params]            = team
            teams.append(team_record)
          }
        }
      }
      teams
    end

    def self.games(options = {:years => [Date.today.year-1, Date.today.year], :seasons => ['pre', 'reg', 'pst']})
      games = []
      options[:seasons].each{|season|
        #sleep(2)
        options[:years].each{|year|
          response = self.get(games_url(:year => year, :season => season))
          if response['league']
            all_games = response['league'].try(:[], 'season_schedule')
            all_games ||= []
            if all_games['games'] && all_games['games']['game']
              all_games['games']['game'].each { |game|
                if game.class.name == 'Hash'
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
                  game_record[:params]            = game
                  game_record[:params]["season_year"] = year.to_s
                  game_record[:params]["season_type"] = season.to_s.upcase
                  games.append(game_record)
                else
                  game_record = {}
                  game_record[:sports_data_guid]  = all_games['games']['id']
                  game_record[:status]            = all_games['games']['status']
                  game_record[:coverage]          = all_games['games']['coverage']
                  game_record[:home_team_guid]    = all_games['games']['home_team']
                  game_record[:away_team_guid]    = all_games['games']['away_team']
                  game_record[:scheduled_at]      = all_games['games']['scheduled']
                  game_record[:home_team_name]    = all_games['games']['game']['home']['name']
                  game_record[:home_team_abbr]    = all_games['games']['game']['home']['alias']
                  game_record[:away_team_name]    = all_games['games']['game']['away']['name']
                  game_record[:away_team_abbr]    = all_games['games']['game']['away']['alias']
                  game_record[:params]            = all_games['games']
                  game_record[:params]["season_year"] = year.to_s
                  game_record[:params]["season_type"] = season.to_s.upcase
                  games.append(game_record)
                end
              }
            end
          end
        }
      }
      games
    end

    def self.game_summary(options = {:game_guid => '270aec5b-f538-44dd-adc6-6ef16667257c'})
      game_summary = []
      response = self.get(game_summary_url(:game_guid => options[:game_guid]))
      game_summary_record = {}
      game_summary_record[:sports_data_guid]        = response['game']['id']
      game_summary_record[:status]                  = response['game']['status']
      game_summary_record[:coverage]                = response['game']['coverage']
      game_summary_record[:sports_data_home_guid]   = response['game']['home_team']
      game_summary_record[:sports_data_away_guid]   = response['game']['away_team']
      game_summary_record[:scheduled_at]            = response['game']['scheduled']
      game_summary_record[:duration]                = response['game']['duration']
      game_summary_record[:attendance]              = response['game']['attendance']
      game_summary_record[:clock]                   = response['game']['clock']
      game_summary_record[:quarter]                 = response['game']['quarter']
      game_summary_record[:params]                  = response
      game_summary.append(game_summary_record)
      game_summary
    end

    def self.play_by_play(options = {:game_guid => '270aec5b-f538-44dd-adc6-6ef16667257c'})
      play_by_play = []
      response = self.get(play_by_play_url(:game_guid => options[:game_guid]))
      play_by_play_record = {}
      play_by_play_record[:sports_data_guid]  = response['game']['id']
      play_by_play_record[:status]            = response['game']['status']
      play_by_play_record[:coverage]          = response['game']['coverage']
      play_by_play_record[:home_team_guid]    = response['game']['home_team']
      play_by_play_record[:away_team_guid]    = response['game']['away_team']
      play_by_play_record[:scheduled]         = response['game']['scheduled']
      play_by_play_record[:duration]          = response['game']['duration']
      play_by_play_record[:attendance]        = response['game']['attendance']
      play_by_play_record[:clock]             = response['game']['clock']
      play_by_play_record[:params]            = response
      play_by_play.append(play_by_play_record)
      play_by_play
    end

    def self.players(options = {})
      players = []
      teams = Sportsdata.nba.teams
      teams.each{|team|
        #sleep(2)
        response = self.get(players_url(:team_guid => team[:sports_data_guid]))
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
              player_record[:params]            = player_array

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
    def self.venues_url
      "league/hierarchy.xml"
    end

    def self.teams_url
      "league/hierarchy.xml"
    end

    def self.games_url(options = {})
      "games/#{options[:year]}/#{options[:season]}/schedule.xml"
    end

    def self.game_summary_url(options = {})
      "games/#{options[:game_guid]}/summary.xml"
    end

    def self.game_box_url(options = {})
      "games/#{options[:game_guid]}/boxscore.xml"
    end

    def self.play_by_play_url(options = {})
      "games/#{options[:game_guid]}/pbp.xml"
    end

    def self.players_url(options = {})
      "teams/#{options[:team_guid]}/profile.xml"
    end
  end
end
