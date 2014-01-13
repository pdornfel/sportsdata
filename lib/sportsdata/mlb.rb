module Sportsdata
  module Mlb
    include Request
    class Exception < ::Exception
    end

    attr_accessor :api_key, :api_mode

    #request methods
    def self.api_key
      Sportsdata.mlb_api_key
    end

    def self.images_api_key
      Sportsdata.mlb_images_api_key
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
      "mlb"
    end

    def self.game_statuses
      [
        ["scheduled" => "The game is on the schedules and ready to play."],
        ["inprogress" => "The first pitch for the game has been received."],
        ["complete" => "The last pitch for the game has been received and statistics are being reviewed."],
        ["closed" => "The game has passed review and MLB has officially closed the game."],
        ["wdelay" => "The game has been delayed because of weather."],
        ["fdelay" => "The game has been delayed because of facility issues."],
        ["odelay" => "The game has been delayed."],
        ["postponed" => "The game has been postponed and will be rescheduled in the future, restarting at the top of the 1st."],
        ["suspended" => "The game has been suspended and will be rescheduled in the future, continuing where they left off."],
        ["maintenance" => "The game failed review and is in the process of being repaired."]
      ]
    end

    def self.lineup_positions
      [
        ["1" => "Pitcher"],
        ["2" => "Catcher"],
        ["3" => "First Base"],
        ["4" => "Second Base"],
        ["5" => "Third Base"],
        ["6" => "Shortstop"],
        ["7" => "Left Field"],
        ["8" => "Centerfield"],
        ["9" => "Right Field"],
        ["10" => "Designated Hitter"],
        ["11" => "Pinch Hitter"],
        ["12" => "Pinch Runner"]
      ]
    end

    def self.roster_positions
      [
        ["1B" => "First base"],
        ["2B" => "Second base"],
        ["3B" => "Third Base"],
        ["SS" => "Shortstop"],
        ["LF" => "Left Field"],
        ["CF" => "Centerfield"],
        ["RF" => "Right Field"],
        ["IF" => "In Field"],
        ["OF" => "Out Field"],
        ["RP" => "Relief Pitcher"],
        ["SP" => "Starting Pitcher"]
      ]
    end

    def self.pitch_types
      [
        ["FA = Fastball"],
        ["SI = Sinker"],
        ["CT = Cutter"],
        ["CU = Curveball"],
        ["SL = Slider"],
        ["CH = Changeup"],
        ["KN = Knuckleball"],
        ["SP = Splitter"],
        ["SC = Screwball"],
        ["FO = Forkball"],
        ["IB = Intentional Ball"],
        ["PI = Pitchout"],
        ["Other"]
      ]
    end

    def self.player_statuses
      [
        ["A" => "Active"],
        ["BRV" => "Bereavement List"],
        ["D7" => "7 Day Disabled List"],
        ["D15" => "15 Day Disabled List"],
        ["D30" => "30 Day Disabled List"],
        ["DES" => "Designated for Assignment"],
        ["NRI" => "Non-roster Invitation"],
        ["RA" => "Rehab Assignment"],
        ["RES" => "Reserve List"],
        ["RL" => "Released"],
        ["RM" => "Reassigned to Minors"],
        ["RST" => "Restricted List"],
        ["SU" => "Suspended List"],
        ["OFS" => "Out For Season"],
        ["PL" => "Paternity Leave"],
      ]
    end

    def self.pitch_outcomes
      [
        ["aD" => "Double"],
        ["aDAD3" => "Double - Adv 3rd"],
        ["aDAD4" => "Double - Adv Home"],
        ["aHBP" => "Hit By Pitch"],
        ["aHR" => "Homerun"],
        ["aROE" => "Reached On Error"],
        ["aS" => "Single"],
        ["aSAD2" => "Single - Adv 2nd"],
        ["aSAD3" => "Single - Adv 3rd"],
        ["aSAD4" => "Single - Adv Home"],
        ["aT" => "Triple"],
        ["aTAD4" => "Triple - Adv Home"],
        ["bB" => "Ball"],
        ["bDB" => "Dirt Ball"],
        ["bIB" => "Intentional Ball"],
        ["bPO" => "Pitchout"],
        ["kF" => "Foul Ball"],
        ["kFT" => "Foul Tip"],
        ["kKL" => "Strike Looking"],
        ["kKS" => "Strike Swinging"],
        ["oFC" => "Fielders Choice"],
        ["oFO" => "Fly Out"],
        ["oGO" => "Ground Out"],
        ["oLO" => "Line Out"],
        ["oPO" => "Pop Out"],
        ["oSB" => "Sacrifice Bunt"],
        ["oSF" => "Sacrifice Fly"],
        ["oST2" => "Single - Out at 2nd"],
        ["oST3" => "Single - Out at 3rd"],
        ["oST4" => "Single - Out at Home"],
        ["oDT3" => "Double - Out at 3rd"],
        ["oDT4" => "Double - Out at Home"],
        ["oTT4" => "Triple - Out at Home"],
        ["oOBB" => "Out of Batters Box"],
        ["oBI" => "Hitter Interference"],
        ["oOP" => "Out on Appeal"],
        ["aCI" => "Catcher Interference"],
        ["aBK" => "Balk"]
      ]
    end

    def self.runner_outcomes
      [
        ["CK = Checked"],
        ["ERN = Earned Run/RBI"],
        ["eRN = Earned Run/No RBI"],
        ["URN = Unearned Run/RBI"],
        ["uRN = Unearned Run/No RBI"],
        ["PO = Pickoff"],
        ["AD2 = Advance 2nd"],
        ["AD3 = Advance 3rd"],
        ["SB2 = Stole 2nd"],
        ["SB3 = Stole 3rd"],
        ["SB4 = Stole Home"],
        ["TO2 = Tag out 2nd"],
        ["TO3 = Tag out 3rd"],
        ["TO4 = Tag out Home"],
        ["FO1 = Force out 1st"],
        ["FO2 = Force out 2nd"],
        ["FO3 = Force out 3rd"],
        ["FO4 = Force out Home"],
        ["CS2 = Caught Stealing 2nd"],
        ["CS3 = Caught Stealing 3rd"],
        ["CS4 = Caught Stealing Home"],
        ["SB2E3 = Stole 2nd, error to 3rd"],
        ["SB2E4 = Stole 2nd, error to Home"],
        ["SB3E4 = Stole 3nd, error to Home"],
        ["DI2 = Indeference to 2nd"],
        ["DI3 = Indeference to 3rd"],
        ["DO1 = Doubled off 1st"],
        ["DO2 = Doubled off 2nd"],
        ["DO3 = Doubled off 3rd"],
        ["RI = Runner Interference"],
        ["OOA = Out on Appeal"],
        ["OBP = Out of Base Path"],
        ["HBB = Hit by Batted Ball"]
      ]
    end

    def self.venues(options = {})
      venues = []
      response = self.get(self.venues_url)
      all_venues = response['venues'].try(:[], 'venue')
      all_venues ||= []
      all_venues.each { |venue|
        venue_record = {}
        venue_record[:sports_data_guid]           = venue['id']
        venue_record[:name]                       = venue['name']
        venue_record[:city]                       = venue['market']
        venue_record[:left_field]                 = venue['distances']['lf']
        venue_record[:left_center_field]          = venue['distances']['lcf']
        venue_record[:center_field]               = venue['distances']['cf']
        venue_record[:right_center_field]         = venue['distances']['rcf']
        venue_record[:right_field]                = venue['distances']['rf']
        venue_record[:middle_left_field]          = venue['distances']['mlf']
        venue_record[:middle_left_center_field]   = venue['distances']['mlcf']
        venue_record[:middle_right_center_field]  = venue['distances']['mrcf']
        venue_record[:middle_right_field]         = venue['distances']['mrf']
        venue_record[:params]                     = venue
        venues.append(venue_record)
      }
      venues
    end

    def self.teams(options = {:years => [Date.today.year-1, Date.today.year]})
      teams = []
      options[:years].each{|year|
        response = self.get(self.teams_url(:year => year))
        all_teams = response['teams'].try(:[], 'team')
        all_teams ||= []
        all_teams.each { |team|
          team_record = {}
          team_record[:sports_data_guid]  = team['id']
          team_record[:abbr]              = team['abbr']
          team_record[:name]              = team['name']
          team_record[:city]              = team['market']
          team_record[:league]            = team['league']
          team_record[:division]          = team['division']
          team_record[:venue_guid]        = team['venue']
          team_record[:params]            = team
          teams.append(team_record)
        }
      }
      teams
    end

    def self.games(options = {:years => [Date.today.year-1, Date.today.year]})
      games = []
      options[:years].each{|year|
        response = self.get(self.games_url(:year => year))
        if response['calendars']
          all_games = response['calendars'].try(:[], 'event')
          all_games ||= []
          all_games.each { |game|
            game_record = {}
            game_record[:sports_data_guid]    = game['id']
            game_record[:scheduled_at]        = game['scheduled_start']
            game_record[:season_type]         = game['season_type']
            game_record[:status]              = game['status']
            game_record[:away_team_guid]      = game['visitor']
            game_record[:home_team_guid]      = game['home']
            game_record[:venue_guid]          = game['venue']
            game_record[:tbd]                 = game['tbd']
            game_record[:broadcast_network]   = game['broadcast']['network']
            game_record[:broadcast_satellite] = game['broadcast']['satellite']
            game_record[:broadcast_internet]  = game['broadcast']['internet']
            game_record[:broadcast_cable]     = game['broadcast']['cable']
            game_record[:params]              = game
            games.append(game_record)
          }
        end
      }
      games
    end

    def self.game_summary(options = {:event_id => '270aec5b-f538-44dd-adc6-6ef16667257c'})
      game_summary = []
      response = self.get(self.game_statistics_url(:event_id => options[:event_id]))
      game_summary_record = {}
      game_summary_record[:sports_data_guid]        = response['statistics']['id']
      game_summary_record[:status]                  = response['statistics']['status']
      game_summary_record[:params]                  = response
      game_summary.append(game_summary_record)
      game_summary
    end

    def self.play_by_play(options = {:event_id => '99a0f209-2c69-49a4-99f9-8aebdf55b6e9'})
      play_by_play = []
      response = self.get(self.play_by_play_url(:event_id => options[:event_id]))
      play_by_play_record = {}
      play_by_play_record[:sports_data_guid]  = response['play_by_play']['id']
      play_by_play_record[:status]            = response['play_by_play']['status']
      play_by_play_record[:home_team_guid]    = response['play_by_play']['home']
      play_by_play_record[:away_team_guid]    = response['play_by_play']['visitor']
      play_by_play_record[:params]            = response
      play_by_play.append(play_by_play_record)
      play_by_play
    end

    def self.players(options = {:years => [(Date.today - 1.year).year, Date.today.year]})
      players = []
      options[:years].each{|year|
        response = self.get(self.players_url(:year => year))
        all_players = response['rosters'].try(:[], 'team')
        all_players ||= []
        all_players.each { |team|
          if team['players']
            team['players']['profile'].each { |player|
              player_record = {}
              player_record[:team_guid]         = team['id']
              player_record[:team_abbr]         = team['abbr']
              player_record[:team_name]         = team['name']
              player_record[:team_market]       = team['market']
              player_record[:league]            = team['league']
              player_record[:division]          = team['division']
              player_record[:sports_data_guid]  = player['id']
              player_record[:mlbam_id]          = player['mlbam_id']
              player_record[:first_name]        = player['first']
              player_record[:preferred_first]   = player['preferred_first']
              player_record[:last_name]         = player['last']
              player_record[:bat_hand]          = player['bat_hand']
              player_record[:throw_hand]        = player['throw_hand']
              player_record[:weight]            = player['weight']
              player_record[:height]            = player['height']
              player_record[:birthday]          = player['birthdate']
              player_record[:birth_city]        = player['birthcity']
              player_record[:birth_state]       = player['birthstate']
              player_record[:birth_country]     = player['birthcountry']
              player_record[:highschool]        = player['highschool']
              player_record[:college]           = player['college']
              player_record[:pro_debut]         = player['pro_debut']
              player_record[:status]            = player['status']
              player_record[:jersey_number]     = player['jersey']
              player_record[:position]          = player['position']
              player_record[:params]            = player
              players.append(player_record)
            }
          end
        }
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
      "venues/venues.xml"
    end

    def self.teams_url(options = {})
      "teams/#{options[:year]}.xml"
    end

    def self.games_url(options = {})
      "schedule/#{options[:year]}.xml"
    end

    def self.game_statistics_url(options = {})
      "statistics/#{options[:event_id]}.xml"
    end

    def self.game_box_url(options = {})
      "boxscore/#{options[:event_guid]}.xml"
    end

    def self.play_by_play_url(options = {})
      "pbp/#{options[:event_id]}.xml"
    end

    def self.players_url(options = {})
      "rosters-full/#{options[:year]}.xml"
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
