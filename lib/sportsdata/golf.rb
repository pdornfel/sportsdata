module Sportsdata
  module Golf
    include Request
    class Exception < ::Exception
    end
    class Venue < OpenStruct
    end
    class Player < OpenStruct
    end
    class Team < OpenStruct
    end
    class Schedule < OpenStruct
    end
    class Game < OpenStruct
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
      "3"
    end

    def self.name
      'golf'
    end

    def self.player_statuses
      [
        ["CUT"],
        ["WD"]
      ]
    end

    def self.tournament_statuses
      [
        ["scheduled - The tournament is scheduled to occur."],
        ["inprogress – The tournament is in progress."],
        ["complete – The tournament is over, but stat validation is not complete."],
        ["closed – The tournament is over and the stats have been validated."],
        ["reopened – The tournament stats are in the process of being corrected."]
      ]
    end

    def self.round_statuses
      [
        ["scheduled - The round is scheduled to occur."],
        ["delayed – The round has been delayed."],
        ["inprogress – The round is in progress."],
        ["complete – The round is over, but stat validation is not complete."],
        ["closed – The round is over and the stats have been validated."],
        ["reopened – The round stats are in the process of being corrected."]
      ]
    end

    #def self.venues(options = {})
    #  venues = []
    #  response = self.get(self.venues_url)
    #  all_venues = response['league'].try(:[], 'conference')
    #  all_venues ||= []
    #  all_venues.each { |conference|
    #    conference['division'].each { |division|
    #      division['team'].each { |team|
    #        venue_record = {}
    #        venue_record[:name]       = team['venue']['name'].humanize.titlecase
    #        venue_record[:state]      = team['venue']['state']
    #        venue_record[:city]       = team['venue']['city']
    #        venue_record[:guid]       = team['venue']['id']
    #        venue_record[:capacity]   = team['venue']['capacity']
    #        venue_record[:surface]    = team['venue']['surface']
    #        venue_record[:venue_type] = team['venue']['type']
    #        venues.append(Venue.new(venue_record))
    #      }
    #    }
    #  }
    #  venues
    #end

    #def self.teams(options = {})
    #  teams = []
    #  response = self.get(self.teams_url)
    #  all_teams = response['league'].try(:[], 'conference')
    #  all_teams ||= []
    #  all_teams.each { |conference|
    #    team_record = {}
    #    team_record[:league_abbr] = conference['name']
    #    conference['division'].each { |division|
    #      team_record[:division] = division['name']
    #      division['team'].each { |team|
    #        team_record[:guid]  = team['id']
    #        team_record[:abbr]  = team['id']
    #        team_record[:name]  = team['market'] + ' ' + team['name']
    #        team_record[:slug]  = sd.to_slug(team_record['name']).downcase
    #        team_record[:city]  = team['market']
    #        teams.append(Team.new(team_record))
    #      }
    #    }
    #  }
    #  teams
    #end

    ##fetch last year, this year and next year
    ## Their are three season options (PRE, REG, PST)
    #def self.games(options = {:year => Date.today.year, :season => 'REG'})
    #  games = []
    #  response = self.get(games_url(:year => options[:year]))
    #  #games_url(:year => 2012)
    #  #games_url(:year => 2012)
    #  all_games = response['season'].try(:[], 'week')
    #  all_games ||= []
    #  all_games.each { |week|
    #    game_record = {}
    #    game_record[:week]  = week['week']
    #    week['game'].each { |game|
    #      game_record[:guid]      = game['guid']
    #      game_record[:scheduled_at] = game['scheduled']
    #      game_record[:home]      = game['home']
    #      game_record[:away]      = game['away']
    #      game_record[:status]    = game['status']
    #      games.append(Game.new(game_record))
    #    }
    #  }
    #  games
    #end

    def self.players(options = {})
     players = []
     response = self.get(players_url(:team_abbr => 'MIA'))
     all_players = response['team'].try(:[], 'player')
     all_players ||= []
     all_players.each { |player|
       player_record = {}
       player_record[:guid]            = player['id']
       player_record[:name_full]       = player['name_full']
       player_record[:name_first]      = player['name_first']
       player_record[:name_last]       = player['name_last']
       player_record[:name_abbr]       = player['name_abbr']
       player_record[:birthdate]       = player['birthdate']
       player_record[:birth_place]     = player['birth_place']
       player_record[:high_school]     = player['high_school']
       player_record[:height]          = player['height']
       player_record[:weight]          = player['weight']
       player_record[:college]         = player['college']
       player_record[:position]        = player['position']
       player_record[:jersey_number]   = player['jersey_number']
       player_record[:status]          = player['status']
       player_record[:salary]          = player['salary']
       player_record[:experience]      = player['experience']
       player_record[:draft_pick]      = player['draft_pick']
       player_record[:draft_round]     = player['draft_round']
       player_record[:draft_team]      = player['draft_team']
       players.append(Player.new(player_record))
     }
     players
    end

    #private
    #def self.venues_url
    #  "teams/hierarchy.xml"
    #end

    #def self.teams_url
    #  "teams/hierarchy.xml"
    #end

    #def self.games_url(options = {})
    #  "#{options[:year]}/#{options[:season]}/schedule.xml"
    #end

    def self.players_url(options = {})
     "teams/#{options[:team_abbr]}/roster.xml"
    end
  end
end
