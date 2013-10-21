module Sportsdata
  module Nfl
    class Exception < ::Exception
    end

    #include HTTParty
    attr_accessor :api_key, :api_mode
    #default_timeout 15

    def self.api_key
      Sportsdata.nfl_api_key
    end

    def self.api_mode
      Sportsdata.api_mode
    end

    def get_raw(base, url)
      conn = Faraday.new base do |c|
        c.response :xml, :content_type => /\bxml$/
        c.adapter Faraday.default_adapter
      end

      req = conn.get url
      return req.body
    end

    def self.venues(options = {})
      # Create a new SportsData object
      sd = SportsData.new

      # 
      data = sd.get options.first['teams'], options

      # Base URL for Sports Data
      base = "http://api.sportsdatallc.org/nfl-#{options.api_mode}1"

      # URL &  for calling venues
      url = "venus/venues.xml?api_key=#{options.nflapi_key}"

      # Create a venues array
      venues = []

      # 
      xvenues = data['league'].try(:[], 'conference')

      # If xvenues is empty create an array
      xvenues ||= []

      # Create an hash for storing the venues we get back from the API
      venue_record = {}

      # Loop through the xvenues on conference
      xvenues.each { |conference|

        # Loop through the xvenues on division
        conference['division'].each { |division|

          # Loop through the xvenues on team
          division['team'].each { |team|

            # Match API columns to our new hash
            venue_record['name']              = team['venue']['name']
            venue_record['slug']              = sd.to_slug(team['venue']['name']).downcase
            venue_record['url']               = ''
            venue_record['state']             = sd.get_state(team['venue']['state'])
            venue_record['city']              = team['venue']['city']
            venue_record['sports_data_guid']  = team['venue']['id']
            venue_record['twitter']           = ''
            venue_record['capacity']          = team['venue']['capacity']

            #venue_record['address'] = team['venue']['address']
            venue_record['surface'] = team['venue']['surface']
            venue_record['type'] = team['venue']['type']
            #venue_record['zip'] = team['venue']['zip']

            sport = Sport.where("slug = ?", options.first['sport_abbr']).first

            if venue_record
              team_venue = Venue.new(
                :name => venue_record['name'].humanize.titlecase,
                :slug => venue_record['slug'],
                :url => '',
                :state => venue_record['state'],
                :city => venue_record['city'],
                :sports_data_guid => venue_record['sports_data_guid'],
                :twitter => '',
                :capacity => venue_record['capacity'],
                :surface => venue_record['surface'],
                :venue_type => venue_record['type'],
                :left_field => '',
                :left_center_field => '',
                :center_field => '',
                :right_center_field => '',
                :right_field => '',
                :middle_left_field => '',
                :middle_left_center_field => '',
                :middle_right_field => '',
                #:address => venue_record['address'],
                #venue_record['zip'] = team['venue']['zip']
                :sport_id => sport.id,
              )
            else
              return nil
            end
            venues.append(team_venue)
          }
        }
      }
      venues_cache = {}
      venues.each do | t |
        venue = Venue.where("sports_data_guid = ?", t['sports_data_guid']).first
        venue ||= t
        venue.save
        venues_cache[venue.sports_data_guid] = venue
      end



    end

    def self.teams(options = {})
      #puts self.api_key
      []
    end

    def self.players(options = {})
      []
    end

    def self.games(options = {})
      []
    end

    def self.schedules(options = {})
      []
    end

    private
    def self.base_url
    end

    def self.errors
      @errors = {
        0 => "OK",
        1 => "No Response"
      }
    end
  end
end
