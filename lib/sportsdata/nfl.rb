module Sportsdata
  module Nfl
    class Exception < ::Exception
    end

    attr_accessor :api_key, :api_mode

    def self.season_types
      [
        ['PRE' => 'Pre-season game'],
        ['REG' => 'Regular season game'],
        ['PST' => 'Post season game']
      ]
    end

    def self.game_statuses
      [
        ['scheduled' => 'The game is scheduled to occur.'],
        ['created' => 'We are ready to begin recording actions against a scheduled game.'],
        ['inprogress' => 'The game is in progress.'],
        ['complete' => 'The game is over, but stat validation is not complete.'],
        ['closed' => 'The game is over and the stats have been validated.'],
        ['reopened' => 'The game stats are in the process of being corrected.'],
        ['delayed' => 'The start of the game has been delayed, or a game that was in progress is currently delayed.']
      ]
    end

    def self.player_status
      [
        ['ACT' => 'Active'],
        ['DUP' => 'Duplicate'],
        ['EXE' => 'Exempt'],
        ['IR' => 'Injured Reserve'],
        ['NON' => 'Non football related injured reserve'],
        ['NWT' => 'Not with Team'],
        ['PRA' => 'Practice Squad'],
        ['PUP' => 'Physically unable to perform'],
        ['RET' => 'Retired'],
        ['SUS' => 'Suspended'],
        ['UDF' => 'Unsigned draft pick'],
        ['UFA' => 'Unsigned free agent']
      ]
    end

    def self.player_game_statuses
      [
        ['DOU' => 'Doubtful'],
        ['OUT' => 'Out of game'],
        ['PRO' => 'Probable'],
        ['QST' => 'Questionable'],
        ['UNK' => 'Unknown']
      ]
    end

    def self.player_practice_statuses
      [
        ['Did Not Participate' => 'The player did not participate in practice'],
        ['Full Participation' => 'The player participated in practice'],
        ['OUT' => 'The player is out of games and practices']
      ]
    end

    def self.event_types
      [
        ['cointoss'],
        ['timeout'],
        ['injurytimeout'],
        ['tvtimeout'],
        ['challenge'],
        ['review'],
        ['quarterend'],
        ['twominuteswarning'],
        ['miscnote'],
        ['gameover']
      ]
    end

    def self.play_types
      [
        ['penalty'],
        ['kick'],
        ['punt'],
        ['rush'],
        ['pass'],
        ['tackle'],
        ['fieldgoal'],
        ['extrapoint'],
        ['conversion']
      ]
    end

    def self.position_types
      [
        ['C' => 'Center'],
        ['CB' => 'Cornerback'],
        ['DE' => 'Defensive End'],
        ['DT' => 'Defensive Tackle'],
        ['FB' => 'Fullback'],
        ['FS' => 'Free Safety'],
        ['G' => 'Offensive Guard'],
        ['H' => 'Holder'],
        ['K' => 'Kicker'],
        ['KR' => 'Kick Returner'],
        ['LB' => 'Linebacker'],
        ['LDE' => 'Left Defensive End'],
        ['LDT' => 'Left Defensive Tackle'],
        ['LG' => 'Left Guard'],
        ['LILB' => 'Left Inside Linebacker'],
        ['LOLB' => 'Left Outside Linebacker'],
        ['LS' => 'Long Snapper'],
        ['LT' => 'Left Tackle'],
        ['MLB' => 'Middle Linebacker'],
        ['NT' => 'Nose Tackle'],
        ['OG' => 'Offensive Guard'],
        ['OL' => 'Offensive Lineman'],
        ['OLB' => 'Outside Linebacker'],
        ['OT' => 'Offensive Tackle'],
        ['P' => 'Punter'],
        ['PK' => 'Place Kicker'],
        ['PR' => 'Punt Returner'],
        ['QB' => 'Quarterback'],
        ['RB' => 'Running Back'],
        ['RDE' => 'Right Defensive End'],
        ['RDT' => 'Right Defensive Tackle'],
        ['RG' => 'Right Guard'],
        ['RILB' => 'Right Inside Linebacker'],
        ['ROLB' => 'Right Outside Linebacker'],
        ['RT' => 'Right Tackle'],
        ['SAF' => 'Safety'],
        ['SLB' => 'Strong Side Linebacker'],
        ['SS' => 'Strong Safety'],
        ['T' => 'Offensive Tackle'],
        ['TE' => 'Tight End'],
        ['WLB' => 'Weak Side Linebacker'],
        ['WR' => 'Wide Receiver']
      ]
    end

    def penalty_codes
      [
        ['o12' => 'Offense - 12 players'],
        ['oaf' => 'Offense - Facemasking'],
        ['ocb' => 'Offense - Chop block pdated 10.14.13'],
        ['ocw' => 'Offense - Clipping'],
        ['odg' => 'Offense - Delay of game'],
        ['odk' => 'Offense - Delay of kickoff'],
        ['ods' => 'Offense - Delay of game at start of either half'],
        ['oec' => 'Offense - Excessive crowd noise'],
        ['oet' => 'Offense - Excessive time outs'],
        ['ofc' => 'Offense - Invalid fair catch signal'],
        ['ofk' => 'Offense - Offside on Free Kick'],
        ['ofm' => 'Offense - Facemask Incidental'],
        ['ofo' => 'Offense - Helmet off'],
        ['ofr' => 'Offense - A punter placekicker or holder who fakes being roughed'],
        ['ofs' => 'Offense - False start'],
        ['ohc' => 'Offense - Horse Collar'],
        ['ohr' => 'Offense - Helping the runner'],
        ['oib' => 'Offense - Illegal block in the back'],
        ['oic' => 'Offense - Illegal crackback block by offense'],
        ['oid' => 'Offense - Ineligible member kicking team beyond scrimmage'],
        ['oif' => 'Offense - Illegal formation'],
        ['oig' => 'Offense - Intentional grounding'],
        ['oih' => 'Offense - Illegal use of hands'],
        ['oim' => 'Offense - Illegal motion'],
        ['oip' => 'Offense - Illegal Procedure'],
        ['oir' => 'Offense - Illegal return'],
        ['ois' => 'Offense - Illegal shift'],
        ['oiu' => 'Offense - Illegal substitution'],
        ['okb' => 'Offense - Kicking a loose ball'],
        ['okk' => 'Offense - Kicking or kneeing opponent'],
        ['oko' => 'Offense - Kicking team player out of bounds'],
        ['ol7' => 'Offense - Less than seven men on offensive line at snap'],
        ['olb' => 'Offense - Illegal low block'],
        ['olp' => 'Offense - Leaping'],
        ['olv' => 'Offense - Leverage'],
        ['onc' => 'Offense - Captains not appearing for coin toss'],
        ['onz' => 'Offense - Neutral zone infraction'],
        ['oob' => 'Offense - Player out of bounds at snap'],
        ['oof' => 'Offense - Offside'],
        ['ooo' => 'Offense - First onside kickoff out of bounds'],
        ['opb' => 'Offense - Forward pass thrown from beyond line of scrimmage'],
        ['opd' => 'Offense - Ineligible player downfield during passing down'],
        ['opf' => 'Offense - Personal Foul'],
        ['opi' => 'Offense - Pass interference'],
        ['opo' => 'Offense - Piling on'],
        ['ops' => 'Offense - Illegal Forward Pass'],
        ['opu' => 'Offense - Palpably unfair act'],
        ['ore' => 'Offense - Failure to report change of eligibility'],
        ['ori' => 'Offense - Pass touched or caught by ineligible receiver'],
        ['oso' => 'Offense - Striking opponent on head or neck'],
        ['osp' => 'Offense - Helmet to butt spear or ram'],
        ['otm' => 'Offense - 12 men in the huddle'],
        ['oto' => 'Offense - Pass touched by receiver who went OOB'],
        ['ouh' => 'Offense - Holding'],
        ['d12' => '12 players'],
        ['daf' => 'Facemasking'],
        ['dcw' => 'Clipping'],
        ['ddg' => 'Delay of game'],
        ['ddk' => 'Delay of kickoff'],
        ['ddq' => 'Defensive disqualification'],
        ['dds' => 'Delay of game at start of either half'],
        ['dec' => 'Excessive crowd noise'],
        ['den' => 'Encroachment'],
        ['det' => 'Excessive time outs'],
        ['dfi' => 'Fair catch interference'],
        ['dfm' => 'Facemask Incidental'],
        ['dfo' => 'Helmet off'],
        ['dgf' => 'Facemasking ball carrier or quarterback'],
        ['dhc' => 'Horse Collar'],
        ['dhk' => 'Running into kicker'],
        ['dho' => 'Striking or shoving a game official'],
        ['dhw' => 'Using a helmet (not worn) as a weapon'],
        ['dib' => 'Illegal block in the back'],
        ['dic' => 'Illegal Contact'],
        ['dif' => 'Illegal formation'],
        ['dih' => 'Illegal use of hands'],
        ['dkb' => 'Kicking a loose ball'],
        ['dko' => 'Kicking or kneeing opponent'],
        ['dla' => 'Team’s late arrival on the field prior to scheduled kickoff'],
        ['dlb' => 'Illegal low block'],
        ['dlp' => 'Leaping'],
        ['dlv' => 'Leverage'],
        ['dnc' => 'Captains not appearing for coin toss'],
        ['dnz' => 'Neutral zone infraction'],
        ['dob' => 'Player out of bounds at snap'],
        ['dof' => 'Offside'],
        ['dpb' => 'Batting or punching a loose ball'],
        ['dpf' => 'Personal Foul'],
        ['dpi' => 'Pass interference'],
        ['dpo' => 'Piling on'],
        ['dpu' => 'Palpably unfair act'],
        ['drc' => 'Roughing the kicker'],
        ['drp' => 'Roughing the passer'],
        ['dsf' => 'Striking opponent with fisti'],
        ['dso' => 'Striking opponent on head or neck'],
        ['dsp' => 'Helmet to butt spear or ram'],
        ['dth' => 'Using top of his helmet unnecessarily'],
        ['dtm' => '12 men in the huddle'],
        ['dtn' => 'Taunting'],
        ['dtr' => 'Tripping'],
        ['duc' => 'Unsportsmanlike conduct'],
        ['duh' => 'Holding'],
        ['dur' => 'Unnecessary roughness']
      ]
    end

    def self.playoff_statuses
      [
        ['division' => 'The team has clinched the division.'],
        ['division_homefield' => 'The team has clinched the division and home field advantage for the playoffs.'],
        ['playoff_berth' => 'The team has clinched a playoff berth.'],
        ['wildcard' => 'The team has clinched the wildcard berth.']
      ]
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
      unless response.empty?
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
      end
      venues
    end

    def self.teams(options = {})
      teams = []
      response = self.get_raw(self.teams_url)
      unless response.empty?
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
      end
      teams
    end

    def self.games(options = {:years => [Date.today.year-1, Date.today.year, Date.today.year+1], :seasons => [:pre, :reg, :pst]})
      games = []
      options[:seasons].each{|season|
        options[:years].each{|year|
          response = self.get_raw(games_url(:year => year, :season => season))
          unless response.empty?
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
      unless response.empty?
        statistics_record = {}
        statistics_record[:sports_data_guid]       = response['game']['id']
        statistics_record[:scheduled_at]           = response['game']['scheduled']
        statistics_record[:sports_data_home_guid]  = response['game']['home']
        statistics_record[:sports_data_away_guid]  = response['game']['away']
        statistics_record[:status]                 = response['game']['status']
        statistics_record[:params]                 = response
        statistics.append(statistics_record)
      end
      statistics
    end

    def self.game_summary(options = {:year => Date.today.year, :season => 'REG', :week => 1, :away_team => 'BAL', :home_team => 'DEN'})
      summary = []
      response = self.get_raw(game_summary_url(:year => options[:year], :season => options[:season], :week => options[:week], :away_team => options[:away_team], :home_team => options[:home_team]))
      unless response.empty?
        summary_record = {}
        summary_record[:sports_data_guid]       = response['game']['id']
        summary_record[:scheduled]              = response['game']['scheduled']
        summary_record[:home]                   = response['game']['home']
        summary_record[:away]                   = response['game']['away']
        summary_record[:status]                 = response['game']['status']
        summary_record[:params]                 = response
        summary.append(summary_record)
      end
      summary
    end

    def self.game_box(options = {:year => Date.today.year, :season => 'REG', :week => 1, :away_team => 'BAL', :home_team => 'DEN'})
      game_box = []
      response = self.get_raw(game_box_url(:year => options[:year], :season => options[:season], :week => options[:week], :away_team => options[:away_team], :home_team => options[:home_team]))
      unless response.empty?
        game_box_record = {}
        game_box_record[:sports_data_guid]      = response['game']['id']
        game_box_record[:scheduled]             = response['game']['scheduled']
        game_box_record[:home_team_guid]        = response['game']['home']
        game_box_record[:away_team_guid]        = response['game']['away']
        game_box_record[:status]                = response['game']['status']
        game_box_record[:quarter]               = response['game']['quarter']
        game_box_record[:clock]                 = response['game']['clock']
        game_box_record[:completed]             = response['game']['completed']
        game_box_record[:params]                = response
        game_box.append(game_box_record)
      end
      game_box
    end

    def self.play_by_play(options = {:year => Date.today.year, :season => 'REG', :week => 1, :away_team => 'BAL', :home_team => 'DEN'})
      play_by_play = []
      response = self.get_raw(play_by_play_url(:year => options[:year], :season => options[:season], :week => options[:week], :away_team => options[:away_team], :home_team => options[:home_team]))
      unless response.empty?
        play_by_play_record = {}
        play_by_play_record['sports_data_guid']   = response['game']['id']
        play_by_play_record['scheduled_at']       = response['game']['scheduled']
        play_by_play_record['status']             = response['game']['status']
        play_by_play_record['home_team']          = response['game']['home']
        play_by_play_record['away_team']          = response['game']['away']
        play_by_play_record['completed']          = response['game']['completed']
        play_by_play_record['params']             = response
        play_by_play.append(play_by_play_record)
      end
      play_by_play
    end

    def self.play_summary(options = {:year => Date.today.year, :season => 'REG', :week => 1, :away_team => 'BAL', :home_team => 'DEN', :play_guid => '748c7397-3f36-41b4-b49b-671c55a04589'})
      play_summary = []
      response = self.get_raw(play_summary_url(:year => options[:year], :season => options[:season], :week => options[:week], :away_team => options[:away_team], :home_team => options[:home_team], :play_guid => options[:play_guid]))
      unless response.empty?
        play_summary_record = {}
        play_summary_record['sports_data_guid']                     = response['play']['id']
        play_summary_record['sports_data_game_guid']                = response['play']['game']
        play_summary_record['sports_data_updated_at']               = response['play']['updated']
        play_summary_record['play_type']                            = response['play']['type']
        play_summary_record['official']                             = response['play']['official']
        play_summary_record['game_clock']                           = response['play']['clock']
        play_summary_record['quarter']                              = response['play']['quarter']
        play_summary_record['controller']                           = response['play']['controller']
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
      end
      play_summary
    end

    def self.players(options = {})
      players = []
      teams = Sportsdata.nfl.teams
      teams.each{|team|
        response = self.get_raw(players_url(:team_abbr => team[:sports_data_guid]))
        unless response.empty?
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
        end
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

    def self.game_summary_url(options = {})
      "#{options[:year]}/#{options[:season]}/#{options[:week]}/#{options[:away_team]}/#{options[:home_team]}/summary.xml"
    end

    def self.game_box_url(options = {})
      "#{options[:year]}/#{options[:season]}/#{options[:week]}/#{options[:away_team]}/#{options[:home_team]}/boxscore.xml"
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

    def self.injuries_url(options = {})
      "#{options[:year]}/#{options[:season]}/#{options[:week]}/#{options[:away_team]}/#{options[:home_team]}/injuries.xml"
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
        debugger
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
