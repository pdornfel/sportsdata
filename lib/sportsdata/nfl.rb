module Sportsdata
  module Nfl
    class Exception < ::Exception
    end

    attr_accessor :api_key, :api_mode

    def self.positions_legend
      {
        'C' => 'Center',
        'CB' => 'Cornerback',
        'DE' => 'Defensive End',
        'DT' => 'Defensive Tackle',
        'FB' => 'Fullback',
        'FS' => 'Free Safety',
        'G' => 'Offensive Guard',
        'H' => 'Holder',
        'K' => 'Kicker',
        'KR' => 'Kick Returner',
        'LB' => 'Linebacker',
        'LDE' => 'Left Defensive End',
        'LDT' => 'Left Defensive Tackle',
        'LG' => 'Left Guard',
        'LILB' => 'Left Inside Linebacker',
        'LOLB' => 'Left Outside Linebacker',
        'LS' => 'Long Snapper',
        'LT' => 'Left Tackle',
        'MLB' => 'Middle Linebacker',
        'NT' => 'Nose Tackle',
        'OG' => 'Offensive Guard',
        'OL' => 'Offensive Lineman',
        'OLB' => 'Outside Linebacker',
        'OT' => 'Offensive Tackle',
        'P' => 'Punter',
        'PK' => 'Place Kicker',
        'PR' => 'Punt Returner',
        'QB' => 'Quarterback',
        'RB' => 'Running Back',
        'RDE' => 'Right Defensive End',
        'RDT' => 'Right Defensive Tackle',
        'RG' => 'Right Guard',
        'RILB' => 'Right Inside Linebacker',
        'ROLB' => 'Right Outside Linebacker',
        'RT' => 'Right Tackle',
        'SAF' => 'Safety',
        'SLB' => 'Strong Side Linebacker',
        'SS' => 'Strong Safety',
        'T' => 'Offensive Tackle',
        'TE' => 'Tight End',
        'WLB' => 'Weak Side Linebacker',
        'WR' => 'Wide Receiver',
      }
    end

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
            venue_record[:params]           = team
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
            team_record[:params]            = team
            teams.append(team_record)
          }
        }
      }
      teams
    end

    def self.games(options = {:years => [Date.today.year-1, Date.today.year, Date.today.year+1], :seasons => [:pre, :reg, :pst]})
      games = []
      options[:seasons].each{|season|
        #sleep(2)
        options[:years].each{|year|
          response = self.get_raw(games_url(:year => year, :season => season))
          if response['season']
            all_games = response['season'].try(:[], 'week')
            all_games ||= []
            all_games.each { |week|
              if week['game'].class.name == 'Array'
                week['game'].each { |game|
                  game_record = {}
                  game_record[:week]              = week['week']
                  game_record[:sports_data_guid]  = game['id']
                  game_record[:venue_guid]        = game['venue']['id']
                  game_record[:scheduled_at]      = game['scheduled']
                  game_record[:home_team_guid]    = game['home']
                  game_record[:away_team_guid]    = game['away']
                  game_record[:status]            = game['status']
                  game_record[:params]            = game
                  games.append(game_record)
                }
              else
                if week['game']
                  game_record = {}
                  game_record[:week]                = week['week']
                  if week.class.name == 'Hash'
                    game_record[:sports_data_guid]  = week['game']['id']
                    game_record[:venue_guid]        = week['game']['venue']['id']
                    game_record[:scheduled_at]      = week['game']['scheduled']
                    game_record[:home_team_guid]    = week['game']['home']
                    game_record[:away_team_guid]    = week['game']['away']
                    game_record[:status]            = week['game']['status']
                    game_record[:params]            = week
                    games.append(game_record)
                  end
                end
              end
            }
          end
        }
      }
      games
    end

    def self.game_statistics(options = {:year => Date.today.year, :season => 'REG', :week => 1, :away_team => 'BAL', :home_team => 'DEN'})
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

    def self.play_by_play(options = {:year => Date.today.year, :season => 'REG', :week => 1, :away_team => 'BAL', :home_team => 'DEN'})
      play_by_play = []
      response = self.get_raw(play_by_play_url(:year => options[:year], :season => options[:season], :week => options[:week], :away_team => options[:away_team], :home_team => options[:home_team]))
      play_by_play_record = {}
      play_by_play_record['sports_data_guid']   = response['game']['id']
      play_by_play_record['scheduled_at']       = response['game']['scheduled']
      play_by_play_record['status']             = response['game']['status']
      play_by_play_record['home_team']          = response['game']['home']
      play_by_play_record['away_team']          = response['game']['away']
      play_by_play_record['completed']          = response['game']['completed']
      play_by_play_record['params']             = response
      play_by_play.append(play_by_play_record)
      play_by_play
    end

    def self.play_summary(options = {:year => Date.today.year, :season => 'REG', :week => 1, :away_team => 'BAL', :home_team => 'DEN', :play_guid => '748c7397-3f36-41b4-b49b-671c55a04589'})
      play_summary = []
      response = self.get_raw(play_summary_url(:year => options[:year], :season => options[:season], :week => options[:week], :away_team => options[:away_team], :home_team => options[:home_team], :play_guid => options[:play_guid]))
      play_summary_record = {}
      play_summary_record['sports_data_guid']                     = response['play']['id']
      play_summary_record['sports_data_game_guid']                = response['play']['game']
      play_summary_record['play_type']                            = response['play']['type']
      play_summary_record['official']                             = response['play']['official']
      play_summary_record['quarter']                              = response['play']['quarter']
      play_summary_record['controller']                           = response['play']['controller']
      play_summary_record['updated_at']                           = response['play']['updated']
      play_summary_record['direction']                            = response['play']['direction']
      play_summary_record['summary']                              = response['play']['summary']
      play_summary_record['start_situation_team']                 = response['play']['start_situation']['team']
      play_summary_record['start_situation_side']                 = response['play']['start_situation']['side']
      play_summary_record['start_situation_yard_line']            = response['play']['start_situation']['yard_line']
      play_summary_record['start_situation_down']                 = response['play']['start_situation']['down']
      play_summary_record['start_situation_yards_to_first_down']  = response['play']['start_situation']['yfd']
      play_summary_record['end_situation_team']                   = response['play']['end_situation']['team']
      play_summary_record['end_situation_side']                   = response['play']['end_situation']['side']
      play_summary_record['end_situation_yard_line']              = response['play']['end_situation']['yard_line']
      play_summary_record['end_situation_down']                   = response['play']['end_situation']['down']
      play_summary_record['end_situation_yards_to_first_down']    = response['play']['end_situation']['yfd']
      play_summary_record['players']                              = response['play']['statistics']['player']
      play_summary_record['params']                               = response
      play_summary.append(play_summary_record)
      play_summary
    end

    def self.players(options = {})
      players = []
      teams = Sportsdata.nfl.teams
      teams.each{|team|
        #sleep(2)
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
          player_record[:params]            = player
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

    def self.play_by_play_url(options = {})
      "#{options[:year]}/#{options[:season]}/#{options[:week]}/#{options[:away_team]}/#{options[:home_team]}/pbp.xml"
    end

    def self.play_summary_url(options = {})
      "#{options[:year]}/#{options[:season]}/#{options[:week]}/#{options[:away_team]}/#{options[:home_team]}/plays/#{options[:play_guid]}.xml"
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
