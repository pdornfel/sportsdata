module Sportsdata
  module Mlb
    class Exception < ::Exception
    end

    #include HTTParty
    attr_accessor :api_key, :api_mode
    #default_timeout 15

    def self.api_key
      Sportsdata.mlb_api_key
    end

    def self.api_mode
      Sportsdata.api_mode
    end

    def self.get_raw(base, url)
      conn = Faraday.new base do |c|
        c.response :xml, :content_type => /\bxml$/
        c.adapter Faraday.default_adapter
      end

      req = conn.get url
      return req.body
    end

    def self.venues(options = {})
      # Base URL for Sports Data
      base = "http://api.sportsdatallc.org/mlb-#{self.api_mode}3"

      # URL &  for calling venues
      url = "venues/venues.xml?api_key=#{self.api_key}"

      # Get XML data
      data = self.get_raw(base, url)

      # Create a venues array
      venues = []

      #
      xvenues = data['venues'].try(:[], 'venue')

      #
      xvenues ||= []

      #
      venue_record = {}

      #
      xvenues.each { |venue|
        sport = Sport.where("slug = ?", options.first['sport_abbr']).first
        venue_record['sports_data_guid'] = venue['id']
        venue_record['name'] = venue['name']
        venue_record['slug'] = sd.to_slug(venue['name']).downcase
        #venue_record['capacity'] = venue['capacity']
        #venue_record['address'] = venue['address']
        venue_record['city'] = venue['market']
        #venue_record['state'] = sd.get_state(venue['state'])
        #venue_record['surface'] = venue['surface']
        #venue_record['type'] = venue['type']
        #venue_record['zip'] = venue['zip']
        venue_record['left_field'] = venue['distances']['lf']
        venue_record['left_center_field'] = venue['distances']['lcf']
        venue_record['center_field'] = venue['distances']['cf']
        venue_record['right_center_field'] = venue['distances']['rcf']
        venue_record['right_field'] = venue['distances']['rf']
        venue_record['middle_left_field'] = venue['distances']['mlf']
        venue_record['middle_left_center_field'] = venue['distances']['mlcf']
        venue_record['middle_right_center_field'] = venue['distances']['mrcf']
        venue_record['middle_right_field'] = venue['distances']['mrf']
        venue_record['sport_id'] = sport.id
        if venue_record
          team_venue = Venue.new(
            :name => venue_record['name'].humanize.titlecase,
            :slug => venue_record['slug'],
            :url => '',
            :state => '',
            :city => venue_record['city'],
            :sports_data_guid => venue_record['sports_data_guid'],
            :twitter => '',
            :capacity => '',
            :surface => '',
            :venue_type => '',
            :left_field => venue_record['left_field'],
            :left_center_field => venue_record['left_center_field'],
            :center_field => venue_record['center_field'],
            :right_center_field => venue_record['right_center_field'],
            :right_field => venue_record['right_field'],
            :middle_left_field => venue_record['middle_left_field'],
            :middle_left_center_field => venue_record['middle_left_center_field'],
            :middle_right_center_field => venue_record['middle_right_center_field'],
            :middle_right_field => venue_record['middle_right_field'],
            #:address => venue_record['address'],
            #venue_record['zip'] = team['venue']['zip']
            :sport_id => sport.id,
          )
        else
          return nil
        end
        venues.append(team_venue)
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
