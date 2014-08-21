module Sportsdata
  module Golf
    include Request
    class Exception < ::Exception
    end
    class Stat < OpenStruct
    end
    class Player < OpenStruct
    end

    attr_accessor :api_key, :api_mode

    #request methods
    def self.api_key
      Sportsdata.golf_api_key
    end

    def self.api_mode
      Sportsdata.api_mode
    end

    def self.version
      "1"
    end

    def self.name
      'golf'
    end

    def self.player_profiles(options = {})
     players = []
     response = self.get(player_profiles_url(:year => '2014'))
     all_players = response['tour']['season']['player']
     all_players ||= []
     all_players.each do |player|
       player_record = {}
       player_record[:uid]            = player['id']
       player_record[:first_name]    = player['first_name']
       player_record[:last_name]     = player['last_name']
       player_record[:height]        = player['height'].to_i
       player_record[:weight]        = player['weight'].to_i
       player_record[:birthday]      = player['birthday']
       player_record[:country]       = player['country']
       player_record[:birth_place]   = player['birth_place']
       player_record[:turned_pro]    = player['turned_pro']
       player_record[:updated]       = player['updated']

       players.append(Player.new(player_record))
     end
     players
    end

    def self.seasonal_stats(options = {})
     stats = []
     response = self.get(self.seasonal_stats_url(year: '2014'))
     seasonal_stats = response['tour']['season']['player']
     seasonal_stats ||= []
     seasonal_stats.each do |stat|
       hash = {}
       hash[:player_uid]      = stat['id']
       hash[:first_name]      = stat['first_name']
       hash[:last_name]       = stat['last_name']
       hash[:events_played]   = stat['statistics']['events_played'].to_i
       hash[:first_place]     = stat['statistics']['first_place'].to_i
       hash[:second_place]    = stat['statistics']['second_place'].to_i
       hash[:third_place]     = stat['statistics']['third_place'].to_i
       hash[:top_10]          = stat['statistics']['top_10'].to_i
       hash[:top_25]          = stat['statistics']['top_25'].to_i
       hash[:withdrawals]     = stat['statistics']['withdrawals'].to_i
       hash[:earnings]        = stat['statistics']['earnings'].to_i
       hash[:earnings_rank]   = stat['statistics']['earnings_rank'].to_i
       hash[:drive_avg]       = stat['statistics']['drive_avg'].to_i
       hash[:drive_acc]       = stat['statistics']['drive_acc'].to_i
       hash[:gir_pct]         = stat['statistics']['gir_pct'].to_i
       hash[:world_rank]      = stat['statistics']['world_rank'].to_i
       hash[:scoring_avg]     = stat['statistics']['scoring_avg'].to_i
           
       stats.append(Stat.new(hash))
     end
     stats
    end

    def self.seasonal_stats_url(options = {})
     "#{self.base_url}/seasontd/pga/#{options[:year]}/players/statistics.xml"
    end

    def self.player_profiles_url(options = {})
     "#{self.base_url}/profiles/pga/#{options[:year]}/players/profiles.xml" 
    end
  end
end
