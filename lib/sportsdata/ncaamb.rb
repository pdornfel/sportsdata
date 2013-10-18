module Sportsdata
  module Ncaamb
    class Exception < ::Exception
    end
    #include HTTParty
    attr_accessor :api_key, :api_mode
    #default_timeout 15

    def self.api_key
      Sportsdata.ncaamb_api_key
    end

    def self.api_mode
      Sportsdata.api_mode
    end

    def self.venues(options = {})
      []
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
