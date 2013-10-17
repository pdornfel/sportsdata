require 'active_support/core_ext/hash'
require 'rubygems'

module Sportsdata
  class Nfl
    #include HTTParty
    attr_accessor :api_key, :api_mode
    #default_timeout 15

    def initialize
      @api_key = Sportsdata.nfl_api_key
      @api_mode = Sportsdata.api_mode
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
      [@host,'/TxWS/ATPayTxWS.asmx'].join('')
    end

    def errors
      @errors = {
      0 => "OK",
      1 => "No Response"
    }
  end
  end
end

