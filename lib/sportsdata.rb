require 'sportsdata/nfl.rb'

module Sportsdata
  class << self
    attr_accessor :nfl_api_key
    attr_accessor :nhl_api_key
    attr_accessor :nba_api_key
    attr_accessor :mlb_api_key
    attr_accessor :ncaafb_api_key
    attr_accessor :ncaamb_api_key
    attr_accessor :api_mode
    attr_accessor :log_level

    def nfl_api_key
      raise "nfl_api_key is not configured" unless @nfl_api_key
      @nfl_api_key
    end

    def nhl_api_key
      raise "nhl_api_key is not configured" unless @nhl_api_key
      @nhl_api_key
    end

    def nba_api_key
      raise "nba_api_key is not configured" unless @nba_api_key
      @nba_api_key
    end

    def mlb_api_key
      raise "mlb_api_key is not configured" unless @mlb_api_key
      @mlb_api_key
    end

    def ncaafb_api_key
      raise "ncaafb_api_key is not configured" unless @ncaafb_api_key
      @ncaafb_api_key
    end

    def ncaamb_api_key
      raise "ncaafb_api_key is not configured" unless @ncaamb_api_key
      @ncaamb_api_key
    end

    DEFAULT_LOG_LEVEL = 'info'

    def log_level
      @log_level || DEFAULT_LOG_LEVEL
    end

  end

  def self.configure(&block)
    yield(self)
  end

end
