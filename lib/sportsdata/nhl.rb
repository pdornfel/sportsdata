module Sportsdata
  class Nhl
    #include HTTParty
    attr_accessor :api_key, :api_mode
    #default_timeout 15

    def self.api_key
      Sportsdata.nhl_api_key
    end

    def self.api_mode
      Sportsdata.api_mode
    end

    def venues(options = {})
      []
    end

    def teams(options = {})
      []
    end

    def players(options = {})
      []
    end

    def games(options = {})
      []
    end

    def schedules(options = {})
      []
    end

    def base_url
    end

    def errors
      @errors = {
        0 => "OK",
        1 => "No Response"
      }
    end
  end
end