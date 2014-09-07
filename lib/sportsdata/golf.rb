module Sportsdata
  module Golf
    include Request
    class Exception < ::Exception
    end
    class Stat < OpenStruct
    end
    class Player < OpenStruct
    end
    class Event < OpenStruct
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

    def self.player_profiles(options = {year: '2014'})
     players = []
     response = self.get(player_profiles_url(options))
     all_players = response['tour']['season']['player']
     all_players ||= []
     all_players.each do |player|
       player_record = {}
       player_record[:uid]            = player['id']
       player_record[:first_name]    = player['first_name']
       player_record[:last_name]     = player['last_name']
       player_record[:height]        = player['height']
       player_record[:weight]        = player['weight']
       player_record[:birthday]      = player['birthday']
       player_record[:country]       = player['country']
       player_record[:birth_place]   = player['birth_place']
       player_record[:turned_pro]    = player['turned_pro']
       player_record[:updated]       = player['updated']

       players.append(Player.new(player_record))
     end
     players
    end

    def self.seasonal_stats(options = {year: '2014'})
     stats = []
     response = self.get(self.seasonal_stats_url(options))
     seasonal_stats = response['tour']['season']['player']
     seasonal_stats ||= []
     seasonal_stats.each do |stat|
       hash = {}
       hash[:player_uid]      = stat['id']
       hash[:first_name]      = stat['first_name']
       hash[:last_name]       = stat['last_name']
       hash[:events_played]   = stat['statistics']['events_played']
       hash[:first_place]     = stat['statistics']['first_place']
       hash[:second_place]    = stat['statistics']['second_place']
       hash[:third_place]     = stat['statistics']['third_place']
       hash[:top_10]          = stat['statistics']['top_10']
       hash[:top_25]          = stat['statistics']['top_25']
       hash[:withdrawals]     = stat['statistics']['withdrawals']
       hash[:earnings]        = stat['statistics']['earnings']
       hash[:earnings_rank]   = stat['statistics']['earnings_rank']
       hash[:drive_avg]       = stat['statistics']['drive_avg']
       hash[:drive_acc]       = stat['statistics']['drive_acc']
       hash[:gir_pct]         = stat['statistics']['gir_pct']
       hash[:world_rank]      = stat['statistics']['world_rank']
       hash[:scoring_avg]     = stat['statistics']['scoring_avg']
           
       stats.append(Stat.new(hash))
     end
     stats
    end

    def self.tournament_schedule(options = {year: '2014'})
     schedule = []
     response = self.get(self.tournament_schedule_url(options))
     full_schedule = response['tour']['season']['tournament']
     full_schedule ||= []
     full_schedule.each do |event|
       hash = {}
       hash[:event_id]           = event['id']
       hash[:event_name]         = event['name']
       hash[:event_type]         = event['event_type']
       hash[:purse]              = event['purse']   
       hash[:event_purse]        = event['event_purse']
       hash[:event_start_date]   = event['start_date']
       hash[:event_end_date]     = event['end_date']
       hash[:venue_name]         = event['venue']['name']
       hash[:city]               = event['venue']['city']
       hash[:state]              = event['venue']['state']
       hash[:country]            = event['venue']['country']
       hash[:course_info]        = event['venue']['course']

       schedule.append(Event.new(hash))
     end
     schedule
    end

    def self.tournament_leaderboard(options)
      default_otpions = {
        year: '2014'
      }
      options = options.reverse_merge(default_otpions)
      leaderboard = []
      response = self.get(self.tournament_leaderboard_url(options))
    end

    def self.tournament_leaderboard_url(options = {})
     "#{self.base_url}/leaderboard/pga/#{options[:year]}/tournaments/#{options[:uid]}/leaderboard.xml"
    end

    def self.player_profiles_url(options = {})
     "#{self.base_url}/profiles/pga/#{options[:year]}/players/profiles.xml" 
    end

    def self.seasonal_stats_url(options = {})
     "#{self.base_url}/seasontd/pga/#{options[:year]}/players/statistics.xml"
    end

    def self.tournament_schedule_url(options = {})
     "#{self.base_url}/schedule/pga/#{options[:year]}/tournaments/schedule.xml"
    end
  end
end
