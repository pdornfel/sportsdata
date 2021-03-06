module Sportsdata
  module Nhl
    include Request
    class Exception < ::Exception
    end

    attr_accessor :api_key, :api_mode

    #request methods
    def self.api_key
      Sportsdata.nhl_api_key
    end

    def self.images_api_key
      Sportsdata.nhl_images_api_key
    end

    def self.api_mode
      Sportsdata.api_mode
    end

    def self.images_api_mode
      Sportsdata.images_api_mode
    end

    def self.version
      "3"
    end

    def self.images_version
      "1"
    end

    def self.name
      "nhl"
    end

    def self.game_statuses
      [
        ["scheduled" => "The game is scheduled to occur."],
        ["inprogress" => "The game is in progress."],
        ["complete" => "The game is over, but stat validation is not complete."],
        ["closed" => "The game is over and the stats have been validated."],
        ["cancelled" => "The game has been cancelled."],
        ["delayed" => "The start of the game is currently delayed or the game has gone from in progress to delayed for some reason."],
        ["postponed" => "The game has been postponed, to be made up at another day and time."],
        ["time-tbd" => "The game has been scheduled, but a time has yet to be announced."],
        ["unnecessary" => "The series game was scheduled to occur, but will not take place due to one team clinching the series early."]
      ]
    end

    def self.player_positions
      [
        ["C"],
        ["D"],
        ["F"],
        ["F-D"],
        ["G"],
        ["LW"],
        ["NA"],
        ["RW"]
      ]
    end

    def self.game_statistics
      [
        ["Assists"],
        ["Blocked Attempts"],
        ["Blocked Shots"],
        ["Even Strength Assists"],
        ["Even Strength Goals"],
        ["Even Strength Missed Shots"],
        ["Even Strength Shots on Goal"],
        ["Goals"],
        ["Missed Shots"],
        ["Penalties"],
        ["Penalty Minutes"],
        ["Penalty Missed Shots"],
        ["Penalty Shots on Goal"],
        ["Points"],
        ["Power Play Assists"],
        ["Power Play Goals"],
        ["Power Play Missed Shots"],
        ["Power Play Shots on Goal"],
        ["Shooting Pct"],
        ["Shootout Goals"],
        ["Shootout Missed Shots"],
        ["Shootout Shots on Goal"],
        ["Short Handed Assists"],
        ["Short Handed Goals"],
        ["Short Handed Missed Shots"],
        ["Short Handed Shots on Goal"],
        ["Shots on Goal"],
        ["Even Strength Goals Against"],
        ["Even Strength Save Percentage"],
        ["Even Strength Saves"],
        ["Even Strength Shots Against"],
        ["Goals Against"],
        ["Penalty Goals Against"],
        ["Penalty Save Percentage"],
        ["Penalty Saves"],
        ["Penalty Shots Against"],
        ["Power Play Goals Against"],
        ["Power Play Save Percentage"],
        ["Power Play Saves"],
        ["Power Play Shots Against"],
        ["Save Pct"],
        ["Saves"],
        ["Shootout Goals Against"],
        ["Shootout Save Percentage"],
        ["Shootout Saves"],
        ["Shootout Shots Against"],
        ["Short Handed Goals Against"],
        ["Short Handed Save Percentage"],
        ["Short Handed Saves"],
        ["Short Handed Shots Against"],
        ["Shots Against"],
        ["Faceoff Win Pct"],
        ["Faceoffs"],
        ["Faceoffs Won"],
        ["Faceoffs Lost"],
        ["Hits"],
        ["Average Time on Ice"],
        ["Even Strength Time on Ice"],
        ["Game Winning Goal Flag"],
        ["Giveaways"],
        ["Plus/Minus"],
        ["Power Play Time on Ice"],
        ["Shifts"],
        ["Short Handed Time on Ice"],
        ["Takeaways"],
        ["Total Time on Ice"],
        ["Outcome"],
        ["Shutout Flag"],
        ["Time on Ice"]
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

    def self.player_statuses
      [
        ["ACT" => "Active"],
        ["CT" => "The player is on the team’s active roster."],
        ["IR" => "Injured reserve"],
        ["M-LEAGUE" => "The player is on the team’s minor league roster."],
        ["NWT" => "The player is no longer with the team."],
        ["SUS" => "Suspended"]
      ]
    end

    def self.event_types
      [
        ["emptynetgoal"],
        ["endperiod"],
        ["endshootoutperiod"],
        ["evenstrength"],
        ["faceoff"],
        ["giveaway"],
        ["goal"],
        ["goaliechange"],
        ["hit"],
        ["penalty"],
        ["penaltygoal"],
        ["penaltyshotmissed"],
        ["penaltyshotsaved"],
        ["powerplay"],
        ["shootoutgoal"],
        ["shootoutshotmissed"],
        ["shootoutshotsaved"],
        ["shotmissed"],
        ["shotsaved"],
        ["startshootoutperiod"],
        ["stoppage"],
        ["takeaway"],
        ["teamtimeout"],
        ["tvtimeout"]
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

    def self.games(options = {:years => [Date.today.year-1, Date.today.year], :seasons => ['reg', 'pst']})
      games = []
      options[:seasons].each{|season|
        options[:years].each{|year|
          response = self.get(self.games_url(:year => year, :season => season.to_s.upcase))
          if response['league']
            all_games = response['league'].try(:[], 'season_schedule')
            all_games ||= []
            if all_games['games']
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
                game_record[:broadcast_network] = game['broadcast']['network'] if game['broadcast']
                game_record[:params]            = game
                game_record[:params]["season_year"] = year.to_s
                game_record[:params]["season_type"] = season.to_s.upcase
                games.append(game_record)
              }
            end
          end
        }
      }
      games
    end

    def self.game_summary(options = {:game_guid => 'c336d44c-d968-4a6b-b8ec-549e03e2816e'})
      game_summary = []
      response = self.get(self.game_summary_url(:game_guid => options[:game_guid]))
      game_summary_record = {}
      game_summary_record[:sports_data_guid]                                    = response['game']['id']
      game_summary_record[:status]                                              = response['game']['status']
      game_summary_record[:coverage]                                            = response['game']['coverage']
      game_summary_record[:sports_data_home_guid]                               = response['game']['home_team']
      game_summary_record[:sports_data_away_guid]                               = response['game']['away_team']
      game_summary_record[:scheduled_at]                                        = response['game']['scheduled']
      game_summary_record[:attendance]                                          = response['game']['attendance']
      game_summary_record[:start_time]                                          = response['game']['start_time']
      game_summary_record[:end_time]                                            = response['game']['end_time']
      game_summary_record[:clock]                                               = response['game']['clock']
      game_summary_record[:period]                                              = response['game']['period']

      #game_summary_record[:sports_data_home_team]                               = response['game']['team'][0]['id']
      #game_summary_record[:home_team]                                           = response['game']['team'][0]['name']
      #game_summary_record[:home_team_market]                                    = response['game']['team'][0]['market']
      #game_summary_record[:home_team_points]                                    = response['game']['team'][0]['points']
      #game_summary_record[:home_team_scoring]                                   = response['game']['team'][0]['scoring'] # array
      #game_summary_record[:home_team_statistics_goal]                           = response['game']['team'][0]['statistics']['goal']
      #game_summary_record[:home_team_statistics_assists]                        = response['game']['team'][0]['statistics']['assists']
      #game_summary_record[:home_team_statistics_penalties]                      = response['game']['team'][0]['statistics']['penalties']
      #game_summary_record[:home_team_statistics_penalty_minutes]                = response['game']['team'][0]['statistics']['penalty_minutes']
      #game_summary_record[:home_team_statistics_team_penalties]                 = response['game']['team'][0]['statistics']['team_penalties']
      #game_summary_record[:home_team_statistics_team_penalty_minutes]           = response['game']['team'][0]['statistics']['team_penalty_minutes']
      #game_summary_record[:home_team_statistics_shots]                          = response['game']['team'][0]['statistics']['shots']
      #game_summary_record[:home_team_statistics_blocked_att]                    = response['game']['team'][0]['statistics']['blocked_att']
      #game_summary_record[:home_team_statistics_missed_shots]                   = response['game']['team'][0]['statistics']['missed_shots']
      #game_summary_record[:home_team_statistics_hits]                           = response['game']['team'][0]['statistics']['hits']
      #game_summary_record[:home_team_statistics_giveaways]                      = response['game']['team'][0]['statistics']['giveaways']
      #game_summary_record[:home_team_statistics_takeaways]                      = response['game']['team'][0]['statistics']['takeaways']
      #game_summary_record[:home_team_statistics_blocked_shots]                  = response['game']['team'][0]['statistics']['blocked_shots']
      #game_summary_record[:home_team_statistics_faceoffs_won]                   = response['game']['team'][0]['statistics']['faceoffs_won']
      #game_summary_record[:home_team_statistics_faceoffs_lost]                  = response['game']['team'][0]['statistics']['faceoffs_lost']
      #game_summary_record[:home_team_statistics_powerplays]                     = response['game']['team'][0]['statistics']['powerplays']
      #game_summary_record[:home_team_statistics_faceoffs]                       = response['game']['team'][0]['statistics']['faceoffs']
      #game_summary_record[:home_team_statistics_faceoff_win_pct]                = response['game']['team'][0]['statistics']['faceoff_win_pct']
      #game_summary_record[:home_team_statistics_shooting_pct]                   = response['game']['team'][0]['statistics']['shooting_pct']
      #game_summary_record[:home_team_statistics_points]                         = response['game']['team'][0]['statistics']['points']
      #game_summary_record[:home_team_statistics_powerplay_faceoffs_won]         = response['game']['team'][0]['statistics']['powerplay']['faceoffs_won']
      #game_summary_record[:home_team_statistics_powerplay_faceoffs_lost]        = response['game']['team'][0]['statistics']['powerplay']['faceoffs_lost']
      #game_summary_record[:home_team_statistics_powerplay_shots]                = response['game']['team'][0]['statistics']['powerplay']['shots']
      #game_summary_record[:home_team_statistics_powerplay_goals]                = response['game']['team'][0]['statistics']['powerplay']['goals']
      #game_summary_record[:home_team_statistics_powerplay_missed_shots]         = response['game']['team'][0]['statistics']['powerplay']['missed_shots']
      #game_summary_record[:home_team_statistics_powerplay_assists]              = response['game']['team'][0]['statistics']['powerplay']['assists']
      #game_summary_record[:home_team_statistics_powerplay_faceoff_win_pct]      = response['game']['team'][0]['statistics']['powerplay']['faceoff_win_pct']
      #game_summary_record[:home_team_statistics_powerplay_faceoffs]             = response['game']['team'][0]['statistics']['powerplay']['faceoffs']
      #game_summary_record[:home_team_statistics_shorthanded_faceoffs_won]       = response['game']['team'][0]['statistics']['shorthanded']['faceoffs_won']
      #game_summary_record[:home_team_statistics_shorthanded_faceoffs_lost]      = response['game']['team'][0]['statistics']['shorthanded']['faceoffs_lost']
      #game_summary_record[:home_team_statistics_shorthanded_shots]              = response['game']['team'][0]['statistics']['shorthanded']['shots']
      #game_summary_record[:home_team_statistics_shorthanded_goals]              = response['game']['team'][0]['statistics']['shorthanded']['goals']
      #game_summary_record[:home_team_statistics_shorthanded_missed_shots]       = response['game']['team'][0]['statistics']['shorthanded']['missed_shots']
      #game_summary_record[:home_team_statistics_shorthanded_assists]            = response['game']['team'][0]['statistics']['shorthanded']['assists']
      #game_summary_record[:home_team_statistics_shorthanded_faceoffs]           = response['game']['team'][0]['statistics']['shorthanded']['faceoffs']
      #game_summary_record[:home_team_statistics_shorthanded_faceoff_win_pct]    = response['game']['team'][0]['statistics']['shorthanded']['faceoff_win_pct']
      #game_summary_record[:home_team_statistics_evenstrength_faceoff_win_pct]   = response['game']['team'][0]['statistics']['evenstrength']['faceoff_win_pct']
      #game_summary_record[:home_team_statistics_evenstrength_missed_shots]      = response['game']['team'][0]['statistics']['evenstrength']['missed_shots']
      #game_summary_record[:home_team_statistics_evenstrength_goals]             = response['game']['team'][0]['statistics']['evenstrength']['goals']
      #game_summary_record[:home_team_statistics_evenstrength_faceoffs_won]      = response['game']['team'][0]['statistics']['evenstrength']['faceoffs_won']
      #game_summary_record[:home_team_statistics_evenstrength_shots]             = response['game']['team'][0]['statistics']['evenstrength']['shots']
      #game_summary_record[:home_team_statistics_evenstrength_faceoffs]          = response['game']['team'][0]['statistics']['evenstrength']['faceoffs']
      #game_summary_record[:home_team_statistics_evenstrength_faceoffs_lost]     = response['game']['team'][0]['statistics']['evenstrength']['faceoffs_lost']
      #game_summary_record[:home_team_statistics_evenstrength_assists]           = response['game']['team'][0]['statistics']['evenstrength']['assists']
      #game_summary_record[:home_team_statistics_penalty_shots]                  = response['game']['team'][0]['statistics']['penalty']['shots']
      #game_summary_record[:home_team_statistics_penalty_goals]                  = response['game']['team'][0]['statistics']['penalty']['goals']
      #game_summary_record[:home_team_statistics_penalty_missed_shots]           = response['game']['team'][0]['statistics']['penalty']['missed_shots']
      #game_summary_record[:home_team_shootout_shots]                            = response['game']['team'][0]['shootout']['shots']
      #game_summary_record[:home_team_shootout_missed_shots]                     = response['game']['team'][0]['shootout']['missed_shots']
      #game_summary_record[:home_team_shootout_goals]                            = response['game']['team'][0]['shootout']['goals']
      #game_summary_record[:home_team_shootout_shots_against]                    = response['game']['team'][0]['shootout']['shots_against']
      #game_summary_record[:home_team_shootout_goals_against]                    = response['game']['team'][0]['shootout']['goals_against']
      #game_summary_record[:home_team_shootout_saves]                            = response['game']['team'][0]['shootout']['saves']
      #game_summary_record[:home_team_shootout_saves_pct]                        = response['game']['team'][0]['shootout']['saves_pct']
      #game_summary_record[:home_team_goaltending_shots_against]                 = response['game']['team'][0]['goaltending']['shots_against']
      #game_summary_record[:home_team_goaltending_goals_against]                 = response['game']['team'][0]['goaltending']['goals_against']
      #game_summary_record[:home_team_goaltending_saves]                         = response['game']['team'][0]['goaltending']['saves']
      #game_summary_record[:home_team_goaltending_saves_pct]                     = response['game']['team'][0]['goaltending']['saves_pct']
      #game_summary_record[:home_team_goaltending_total_shots_against]           = response['game']['team'][0]['goaltending']['total_shots_against']
      #game_summary_record[:home_team_goaltending_total_goals_against]           = response['game']['team'][0]['goaltending']['total_goals_against']
      #game_summary_record[:home_team_goaltending_powerplay_shots_against]       = response['game']['team'][0]['goaltending']['powerplay']['shots_against']
      #game_summary_record[:home_team_goaltending_powerplay_goals_against]       = response['game']['team'][0]['goaltending']['powerplay']['goals_against']
      #game_summary_record[:home_team_goaltending_powerplay_saves]               = response['game']['team'][0]['goaltending']['powerplay']['saves']
      #game_summary_record[:home_team_goaltending_powerplay_saves_pct]           = response['game']['team'][0]['goaltending']['powerplay']['saves_pct']
      #game_summary_record[:home_team_goaltending_shorthanded_shots_against]     = response['game']['team'][0]['goaltending']['shorthanded']['shots_against']
      #game_summary_record[:home_team_goaltending_shorthanded_goals_against]     = response['game']['team'][0]['goaltending']['shorthanded']['goals_against']
      #game_summary_record[:home_team_goaltending_shorthanded_saves]             = response['game']['team'][0]['goaltending']['shorthanded']['saves']
      #game_summary_record[:home_team_goaltending_shorthanded_saves_pct]         = response['game']['team'][0]['goaltending']['shorthanded']['saves_pct']
      #game_summary_record[:home_team_goaltending_evenstrength_shots_against]    = response['game']['team'][0]['goaltending']['evenstrength']['shots_against']
      #game_summary_record[:home_team_goaltending_evenstrength_goals_against]    = response['game']['team'][0]['goaltending']['evenstrength']['goals_against']
      #game_summary_record[:home_team_goaltending_evenstrength_saves]            = response['game']['team'][0]['goaltending']['evenstrength']['saves']
      #game_summary_record[:home_team_goaltending_evenstrength_saves_pct]        = response['game']['team'][0]['goaltending']['evenstrength']['saves_pct']
      #game_summary_record[:home_team_goaltending_penalty_shots_against]         = response['game']['team'][0]['goaltending']['penalty']['shots_against']
      #game_summary_record[:home_team_goaltending_penalty_goals_against]         = response['game']['team'][0]['goaltending']['penalty']['goals_against']
      #game_summary_record[:home_team_goaltending_penalty_saves]                 = response['game']['team'][0]['goaltending']['penalty']['saves']
      #game_summary_record[:home_team_goaltending_penalty_saves_pct]             = response['game']['team'][0]['goaltending']['penalty']['saves_pct']
      #game_summary_record[:home_team_players]                                   = response['game']['team'][0]['players'] # array

      #game_summary_record[:sports_data_home_team]                               = response['game']['team'][1]['id']
      #game_summary_record[:away_team]                                           = response['game']['team'][1]['name']
      #game_summary_record[:away_team_market]                                    = response['game']['team'][1]['market']
      #game_summary_record[:away_team_points]                                    = response['game']['team'][1]['points']
      #game_summary_record[:away_team_scoring]                                   = response['game']['team'][1]['scoring'] # array
      #game_summary_record[:away_team_statistics_goal]                           = response['game']['team'][1]['statistics']['goal']
      #game_summary_record[:away_team_statistics_assists]                        = response['game']['team'][1]['statistics']['assists']
      #game_summary_record[:away_team_statistics_penalties]                      = response['game']['team'][1]['statistics']['penalties']
      #game_summary_record[:away_team_statistics_penalty_minutes]                = response['game']['team'][1]['statistics']['penalty_minutes']
      #game_summary_record[:away_team_statistics_team_penalties]                 = response['game']['team'][1]['statistics']['team_penalties']
      #game_summary_record[:away_team_statistics_team_penalty_minutes]           = response['game']['team'][1]['statistics']['team_penalty_minutes']
      #game_summary_record[:away_team_statistics_shots]                          = response['game']['team'][1]['statistics']['shots']
      #game_summary_record[:away_team_statistics_blocked_att]                    = response['game']['team'][1]['statistics']['blocked_att']
      #game_summary_record[:away_team_statistics_missed_shots]                   = response['game']['team'][1]['statistics']['missed_shots']
      #game_summary_record[:away_team_statistics_hits]                           = response['game']['team'][1]['statistics']['hits']
      #game_summary_record[:away_team_statistics_giveaways]                      = response['game']['team'][1]['statistics']['giveaways']
      #game_summary_record[:away_team_statistics_takeaways]                      = response['game']['team'][1]['statistics']['takeaways']
      #game_summary_record[:away_team_statistics_blocked_shots]                  = response['game']['team'][1]['statistics']['blocked_shots']
      #game_summary_record[:away_team_statistics_faceoffs_won]                   = response['game']['team'][1]['statistics']['faceoffs_won']
      #game_summary_record[:away_team_statistics_faceoffs_lost]                  = response['game']['team'][1]['statistics']['faceoffs_lost']
      #game_summary_record[:away_team_statistics_powerplays]                     = response['game']['team'][1]['statistics']['powerplays']
      #game_summary_record[:away_team_statistics_faceoffs]                       = response['game']['team'][1]['statistics']['faceoffs']
      #game_summary_record[:away_team_statistics_faceoff_win_pct]                = response['game']['team'][1]['statistics']['faceoff_win_pct']
      #game_summary_record[:away_team_statistics_shooting_pct]                   = response['game']['team'][1]['statistics']['shooting_pct']
      #game_summary_record[:away_team_statistics_points]                         = response['game']['team'][1]['statistics']['points']
      #game_summary_record[:away_team_statistics_powerplay_faceoffs_won]         = response['game']['team'][1]['statistics']['powerplay']['faceoffs_won']
      #game_summary_record[:away_team_statistics_powerplay_faceoffs_lost]        = response['game']['team'][1]['statistics']['powerplay']['faceoffs_lost']
      #game_summary_record[:away_team_statistics_powerplay_shots]                = response['game']['team'][1]['statistics']['powerplay']['shots']
      #game_summary_record[:away_team_statistics_powerplay_goals]                = response['game']['team'][1]['statistics']['powerplay']['goals']
      #game_summary_record[:away_team_statistics_powerplay_missed_shots]         = response['game']['team'][1]['statistics']['powerplay']['missed_shots']
      #game_summary_record[:away_team_statistics_powerplay_assists]              = response['game']['team'][1]['statistics']['powerplay']['assists']
      #game_summary_record[:away_team_statistics_powerplay_faceoff_win_pct]      = response['game']['team'][1]['statistics']['powerplay']['faceoff_win_pct']
      #game_summary_record[:away_team_statistics_powerplay_faceoffs]             = response['game']['team'][1]['statistics']['powerplay']['faceoffs']
      #game_summary_record[:away_team_statistics_shorthanded_faceoffs_won]       = response['game']['team'][1]['statistics']['shorthanded']['faceoffs_won']
      #game_summary_record[:away_team_statistics_shorthanded_faceoffs_lost]      = response['game']['team'][1]['statistics']['shorthanded']['faceoffs_lost']
      #game_summary_record[:away_team_statistics_shorthanded_shots]              = response['game']['team'][1]['statistics']['shorthanded']['shots']
      #game_summary_record[:away_team_statistics_shorthanded_goals]              = response['game']['team'][1]['statistics']['shorthanded']['goals']
      #game_summary_record[:away_team_statistics_shorthanded_missed_shots]       = response['game']['team'][1]['statistics']['shorthanded']['missed_shots']
      #game_summary_record[:away_team_statistics_shorthanded_assists]            = response['game']['team'][1]['statistics']['shorthanded']['assists']
      #game_summary_record[:away_team_statistics_shorthanded_faceoffs]           = response['game']['team'][1]['statistics']['shorthanded']['faceoffs']
      #game_summary_record[:away_team_statistics_shorthanded_faceoff_win_pct]    = response['game']['team'][1]['statistics']['shorthanded']['faceoff_win_pct']
      #game_summary_record[:away_team_statistics_evenstrength_faceoff_win_pct]   = response['game']['team'][1]['statistics']['evenstrength']['faceoff_win_pct']
      #game_summary_record[:away_team_statistics_evenstrength_missed_shots]      = response['game']['team'][1]['statistics']['evenstrength']['missed_shots']
      #game_summary_record[:away_team_statistics_evenstrength_goals]             = response['game']['team'][1]['statistics']['evenstrength']['goals']
      #game_summary_record[:away_team_statistics_evenstrength_faceoffs_won]      = response['game']['team'][1]['statistics']['evenstrength']['faceoffs_won']
      #game_summary_record[:away_team_statistics_evenstrength_shots]             = response['game']['team'][1]['statistics']['evenstrength']['shots']
      #game_summary_record[:away_team_statistics_evenstrength_faceoffs]          = response['game']['team'][1]['statistics']['evenstrength']['faceoffs']
      #game_summary_record[:away_team_statistics_evenstrength_faceoffs_lost]     = response['game']['team'][1]['statistics']['evenstrength']['faceoffs_lost']
      #game_summary_record[:away_team_statistics_evenstrength_assists]           = response['game']['team'][1]['statistics']['evenstrength']['assists']
      #game_summary_record[:away_team_statistics_penalty_shots]                  = response['game']['team'][1]['statistics']['penalty']['shots']
      #game_summary_record[:away_team_statistics_penalty_goals]                  = response['game']['team'][1]['statistics']['penalty']['goals']
      #game_summary_record[:away_team_statistics_penalty_missed_shots]           = response['game']['team'][1]['statistics']['penalty']['missed_shots']
      #game_summary_record[:away_team_shootout_shots]                            = response['game']['team'][1]['shootout']['shots']
      #game_summary_record[:away_team_shootout_missed_shots]                     = response['game']['team'][1]['shootout']['missed_shots']
      #game_summary_record[:away_team_shootout_goals]                            = response['game']['team'][1]['shootout']['goals']
      #game_summary_record[:away_team_shootout_shots_against]                    = response['game']['team'][1]['shootout']['shots_against']
      #game_summary_record[:away_team_shootout_goals_against]                    = response['game']['team'][1]['shootout']['goals_against']
      #game_summary_record[:away_team_shootout_saves]                            = response['game']['team'][1]['shootout']['saves']
      #game_summary_record[:away_team_shootout_saves_pct]                        = response['game']['team'][1]['shootout']['saves_pct']
      #game_summary_record[:away_team_goaltending_shots_against]                 = response['game']['team'][1]['goaltending']['shots_against']
      #game_summary_record[:away_team_goaltending_goals_against]                 = response['game']['team'][1]['goaltending']['goals_against']
      #game_summary_record[:away_team_goaltending_saves]                         = response['game']['team'][1]['goaltending']['saves']
      #game_summary_record[:away_team_goaltending_saves_pct]                     = response['game']['team'][1]['goaltending']['saves_pct']
      #game_summary_record[:away_team_goaltending_total_shots_against]           = response['game']['team'][1]['goaltending']['total_shots_against']
      #game_summary_record[:away_team_goaltending_total_goals_against]           = response['game']['team'][1]['goaltending']['total_goals_against']
      #game_summary_record[:away_team_goaltending_powerplay_shots_against]       = response['game']['team'][1]['goaltending']['powerplay']['shots_against']
      #game_summary_record[:away_team_goaltending_powerplay_goals_against]       = response['game']['team'][1]['goaltending']['powerplay']['goals_against']
      #game_summary_record[:away_team_goaltending_powerplay_saves]               = response['game']['team'][1]['goaltending']['powerplay']['saves']
      #game_summary_record[:away_team_goaltending_powerplay_saves_pct]           = response['game']['team'][1]['goaltending']['powerplay']['saves_pct']
      #game_summary_record[:away_team_goaltending_shorthanded_shots_against]     = response['game']['team'][1]['goaltending']['shorthanded']['shots_against']
      #game_summary_record[:away_team_goaltending_shorthanded_goals_against]     = response['game']['team'][1]['goaltending']['shorthanded']['goals_against']
      #game_summary_record[:away_team_goaltending_shorthanded_saves]             = response['game']['team'][1]['goaltending']['shorthanded']['saves']
      #game_summary_record[:away_team_goaltending_shorthanded_saves_pct]         = response['game']['team'][1]['goaltending']['shorthanded']['saves_pct']
      #game_summary_record[:away_team_goaltending_evenstrength_shots_against]    = response['game']['team'][1]['goaltending']['evenstrength']['shots_against']
      #game_summary_record[:away_team_goaltending_evenstrength_goals_against]    = response['game']['team'][1]['goaltending']['evenstrength']['goals_against']
      #game_summary_record[:away_team_goaltending_evenstrength_saves]            = response['game']['team'][1]['goaltending']['evenstrength']['saves']
      #game_summary_record[:away_team_goaltending_evenstrength_saves_pct]        = response['game']['team'][1]['goaltending']['evenstrength']['saves_pct']
      #game_summary_record[:away_team_goaltending_penalty_shots_against]         = response['game']['team'][1]['goaltending']['penalty']['shots_against']
      #game_summary_record[:away_team_goaltending_penalty_goals_against]         = response['game']['team'][1]['goaltending']['penalty']['goals_against']
      #game_summary_record[:away_team_goaltending_penalty_saves]                 = response['game']['team'][1]['goaltending']['penalty']['saves']
      #game_summary_record[:away_team_goaltending_penalty_saves_pct]             = response['game']['team'][1]['goaltending']['penalty']['saves_pct']
      #game_summary_record[:away_team_players]                                   = response['game']['team'][1]['players'] # array
      game_summary_record[:params]                                              = response
      game_summary.append(game_summary_record)
      game_summary
    end

    def self.game_box(options = {:game_guid => 'c336d44c-d968-4a6b-b8ec-549e03e2816e'})
      game_box = []
      response = self.get(self.game_box_url(:game_guid => options[:game_guid]))
      game_box_record = {}
      game_box_record[:sports_data_guid]  = response['game']['id']
      game_box_record[:status]            = response['game']['status']
      game_box_record[:coverage]          = response['game']['coverage']
      game_box_record[:home_team]         = response['game']['home_team']
      game_box_record[:away_team]         = response['game']['away_team']
      game_box_record[:scheduled]         = response['game']['scheduled']
      game_box_record[:attendance]        = response['game']['attendance']
      game_box_record[:start_time]        = response['game']['start_time']
      game_box_record[:end_time]          = response['game']['end_time']
      game_box_record[:clock]             = response['game']['clock']
      game_box_record[:period]            = response['game']['period']
      game_box_record[:params]            = response
      game_box.append(game_box_record)
      game_box
    end

    def self.play_by_play(options = {:game_guid => 'c336d44c-d968-4a6b-b8ec-549e03e2816e'})
      play_by_play = []
      response = self.get(self.play_by_play_url(:game_guid => options[:game_guid]))
      play_by_play_record = {}
      play_by_play_record[:sport_data_guid]   = response['game']['id']
      play_by_play_record[:status]            = response['game']['status']
      play_by_play_record[:coverage]          = response['game']['coverage']
      play_by_play_record[:home_team_guid]    = response['game']['home_team']
      play_by_play_record[:away_team_guid]    = response['game']['away_team']
      play_by_play_record[:scheduled]         = response['game']['scheduled']
      play_by_play_record[:attendance]        = response['game']['attendance']
      play_by_play_record[:start_time]        = response['game']['start_time']
      play_by_play_record[:end_time]          = response['game']['end_time']
      play_by_play_record[:clock]             = response['game']['clock']
      play_by_play_record[:params]            = response
      play_by_play.append(play_by_play_record)
      play_by_play_record
    end

    def self.players(options = {})
      players = []
      teams = Sportsdata.nhl.teams
      teams.each{|team|
        #sleep(2)
        response = self.get(self.players_url(:team_guid => team[:sports_data_guid]))
        all_players = response['team'].try(:[], 'players')
        all_players ||= []
        if all_players.count > 0
          all_players['player'].each { |player|
            player_record = {}
            player_record[:team_guid]         = team[:sports_data_guid]
            player_record[:sports_data_guid]  = player['id']
            player_record[:status]            = player['status']
            player_record[:full_name]         = player['full_name']
            player_record[:first_name]        = player['first_name']
            player_record[:last_name]         = player['last_name']
            player_record[:abbr_name]         = player['abbr_name']
            player_record[:height]            = player['height']
            player_record[:weight]            = player['weight']
            player_record[:handedness]        = player['handedness']
            player_record[:position]          = player['position']
            player_record[:primary_position]  = player['primary_position']
            player_record[:jersey_number]     = player['jersey_number']
            player_record[:experience]        = player['experience']
            player_record[:birth_place]       = player['birth_place']
            player_record[:birthday]          = player['birthdate']
            player_record[:updated]           = player['updated']
            player_record[:params]            = player

            if player['draft'] && player['draft']['team_id']
              player_record[:draft_team_guid]   = player['draft']['team_id']
              player_record[:draft_year]        = player['draft']['year']
              player_record[:draft_round]       = player['draft']['round']
              player_record[:draft_pick]        = player['draft']['pick']
            end

            #player_record[:injury_guid]       = player['injuries']['injury']['id']
            #player_record[:injury_description]= player['injuries']['injury']['desc']
            #player_record[:injury_status]= player['injuries']['injury']['status']
            #player_record[:injury_start_date]= player['injuries']['injury']['start_date']
            players.append(player_record)
          }
        end
      }
      players
    end

    def self.manifest_schema
      response = self.images_get(self.schema_manifest_url)
    end

    def self.manifest_feed(options = {:image_type => 'headshot'})
      players = []
      response = self.images_get(self.feed_manifest_url(:image_type => options[:image_type]))
      all_players = response['assetlist'].try(:[], 'asset')
      all_players.each{|player|
        player_record = {}
        player_record[:title]                   = player['title']
        player_record[:description]             = player['description']
        player_record[:player_image]            = player['links']['link'][0]['href']
        player_record[:sports_data_image_guid]  = player['id']
        player_record[:sports_data_player_guid] = player['player_id']
        player_record[:sports_data_created]     = player['created']
        player_record[:sports_data_updated]     = player['updated']
        players.append(player_record)
      }
      players
    end

    def self.player_image(options = {:image_type => 'headshot', :asset_id => 'edc6920e-0933-4d61-bd6f-a60c64d12b3d', :filename => 1658, :format => 'jpg'})
      players = []
      response = self.images_get(self.images_url(:image_type => options[:image_type], :asset_id => options[:asset_id], :filename => options[:filename], :format => options[:format]))
      response
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

    def self.schema_manifest_url
      "schema/manifest-v1.0.xsd"
    end

    def self.feed_manifest_url(options = {})
      "manifests/#{options[:image_type]}/all_assets.xml"
    end

    def self.images_url(options = {})
      "#{options[:image_type]}/#{options[:asset_id]}/#{options[:filename]}.#{options[:format]}"
    end
  end
end
