module Sportsdata
  module Mlb
    class Exception < ::Exception
    end

    attr_accessor :api_key, :api_mode

    def self.api_key
      Sportsdata.mlb_api_key
    end

    def self.api_mode
      Sportsdata.api_mode
    end

    def self.venues(options = {})
      venues = []
      response = self.get_raw(self.venues_url)
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
        venues.append(venue_record)
      }
      venues
    end

    def self.teams(options = {:year => Date.today.year})
      teams = []
      response = self.get_raw(self.teams_url(:year => options[:year]))
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
        teams.append(team_record)
      }
      teams
    end

    def self.games(options = {:years => [Date.today.year-1, Date.today.year, Date.today.year+1]})
      games = []
      options[:years].each{|year|
        response = self.get_raw(games_url(:year => year))
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
            games.append(game_record)
          }
        end
      }
      games
    end

    def self.players(options = {:years => [Date.today.year-1, Date.today.year, Date.today.year+1]})
      players = []
      options[:years].each{|year|
        response = self.get_raw(players_url(:year => year))
        all_players = response['rosters'].try(:[], 'team')
        all_players ||= []
        all_players.each { |team|
          if team['players']
            team['players']['profile'].each { |player|
              player_record = {}
              player_record[:team_guid]       = team['id']
              player_record[:team_abbr]       = team['abbr']
              player_record[:team_name]       = team['name']
              player_record[:team_market]     = team['market']
              player_record[:league]          = team['league']
              player_record[:division]        = team['division']
              player_record[:player_guid]     = player['id']
              player_record[:mlbam_id]        = player['mlbam_id']
              player_record[:first_name]      = player['first']
              player_record[:preferred_first] = player['preferred_first']
              player_record[:last]            = player['last']
              player_record[:bat_hand]        = player['bat_hand']
              player_record[:throw_hand]      = player['throw_hand']
              player_record[:weight]          = player['weight']
              player_record[:height]          = player['height']
              player_record[:birthdate]       = player['birthdate']
              player_record[:birthcity]       = player['birthcity']
              player_record[:birthstate]      = player['birthstate']
              player_record[:birthcountry]    = player['birthcountry']
              player_record[:highschool]      = player['highschool']
              player_record[:college]         = player['college']
              player_record[:pro_debut]       = player['pro_debut']
              player_record[:status]          = player['status']
              player_record[:jersey]          = player['jersey']
              player_record[:position]        = player['position']
              players.append(player_record)
            }
          end
        }
      }
      players
    end

    private
    def self.version
      "3"
    end

    def self.base_url
      "http://api.sportsdatallc.org/mlb-#{self.api_mode}#{self.version}"
    end

    def self.venues_url
      "venues/venues.xml"
    end

    def self.teams_url(options = {})
      "teams/#{options[:year]}.xml"
    end

    def self.games_url(options = {})
      "schedule/#{options[:year]}.xml"
    end

    def self.players_url(options = {})
      "rosters-full/#{options[:year]}.xml"
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
