module Sportsdata
  module Nfl
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

    #include HTTParty
    attr_accessor :api_key, :api_mode
    #default_timeout 15

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
            venue_record[:name]              = team['venue']['name'].humanize.titlecase
            venue_record[:state]             = team['venue']['state']
            venue_record[:city]              = team['venue']['city']
            venue_record[:guid]  = team['venue']['id']
            venue_record[:capacity]          = team['venue']['capacity']
            venue_record[:surface]           = team['venue']['surface']
            venue_record[:venue_type]        = team['venue']['type']
            venues.append(Venue.new(venue_record))
          }
        }
      }
      venues
    end

    def self.teams(options = {})
      raise Sportsdata::Exception.new("Sportsdata could not be reached")
    end

    def self.teamsx(options = {})
      # Base URL for Sports Data
      base = "http://api.sportsdatallc.org/nfl-#{self.api_mode}1"

      # URL &  for calling venues
      url = "teams/hierarchy.xml?api_key=#{self.api_key}"

      # Get XML data
      data = self.get_raw(base, url)

    end

    def self.players(options = {})
      raise Sportsdata::Exception.new("Sportsdata could not be reached")
    end

    def self.games(options = {})
      []
      raise Sportsdata::Exception.new("Sportsdata could not be reached")
    end

    def self.schedules(options = {})
      []
      raise Sportsdata::Exception.new("Sportsdata could not be reached")
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
