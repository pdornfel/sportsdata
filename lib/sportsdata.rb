require 'ostruct'
require 'open-uri'
require 'faraday_middleware'
require 'active_support/all'

module Sportsdata
  class << self
    attr_accessor :nfl_api_key
    attr_accessor :nfl_images_api_key
    attr_accessor :mlb_api_key
    attr_accessor :mlb_images_api_key
    attr_accessor :nhl_api_key
    attr_accessor :nhl_images_api_key
    attr_accessor :nba_api_key
    attr_accessor :nba_images_api_key
    attr_accessor :ncaafb_api_key
    attr_accessor :ncaafb_images_api_key
    attr_accessor :ncaamb_api_key
    attr_accessor :ncaamb_images_api_key
    attr_accessor :nascar_api_key
    attr_accessor :nascar_images_api_key
    attr_accessor :golf_api_key
    attr_accessor :golf_images_api_key
    attr_accessor :api_mode
    attr_accessor :images_api_mode
    attr_accessor :log_level
    attr_accessor :nfl

    def configure(&block)
      yield(self)
    end

    def sports
      hash = {
        :nfl => nfl,
        :nhl => nhl,
        :nba => nba,
        :mlb => mlb,
        :ncaafb => ncaafb,
        :ncaamb => ncaamb,
        :nascar => nascar,
        :golf => golf
      }
      OpenStruct.new(hash)
    end

    def nfl
      Sportsdata::Nfl
    end

    def nhl
      Sportsdata::Nhl
    end

    def nba
      Sportsdata::Nba
    end

    def mlb
      Sportsdata::Mlb
    end

    def ncaafb
      Sportsdata::Ncaafb
    end

    def ncaamb
      Sportsdata::Ncaamb
    end

    def nascar
      Sportsdata::Nascar
    end

    def golf
      Sportsdata::Golf
    end

    def nfl_api_key
      raise Sportsdata::Exception, "nfl_api_key is not configured" unless @nfl_api_key
      @nfl_api_key
    end

    def nfl_images_api_key
      raise Sportsdata::Exception, "nfl_images_api_key is not configured" unless @nfl_images_api_key
      @nfl_images_api_key
    end

    def nhl_api_key
      raise Sportsdata::Exception, "nhl_api_key is not configured" unless @nhl_api_key
      @nhl_api_key
    end

    def nhl_images_api_key
      raise Sportsdata::Exception, "nhl_images_api_key is not configured" unless @nhl_images_api_key
      @nhl_images_api_key
    end

    def nba_api_key
      raise Sportsdata::Exception, "nba_api_key is not configured" unless @nba_api_key
      @nba_api_key
    end

    def nba_images_api_key
      raise Sportsdata::Exception, "nba_images_api_key is not configured" unless @nba_images_api_key
      @nba_images_api_key
    end

    def mlb_api_key
      raise Sportsdata::Exception, "mlb_api_key is not configured" unless @mlb_api_key
      @mlb_api_key
    end

    def mlb_images_api_key
      raise Sportsdata::Exception, "mlb_images_api_key is not configured" unless @mlb_images_api_key
      @mlb_images_api_key
    end

    def ncaafb_api_key
      raise Sportsdata::Exception, "ncaafb_api_key is not configured" unless @ncaafb_api_key
      @ncaafb_api_key
    end

    def ncaafb_images_api_key
      raise Sportsdata::Exception, "ncaafb_images_api_key is not configured" unless @ncaafb_images_api_key
      @ncaafb_images_api_key
    end

    def ncaamb_api_key
      raise Sportsdata::Exception, "ncaamb_api_key is not configured" unless @ncaamb_api_key
      @ncaamb_api_key
    end

    def ncaamb_images_api_key
      raise Sportsdata::Exception, "ncaamb_images_api_key is not configured" unless @ncaamb_images_api_key
      @ncaamb_images_api_key
    end

    def nascar_api_key
      raise Sportsdata::Exception, "nascar_api_key is not configured" unless @nascar_api_key
      @nascar_api_key
    end

    def nascar_images_api_key
      raise Sportsdata::Exception, "nascar_images_api_key is not configured" unless @nascar_images_api_key
      @nascar_images_api_key
    end

    def golf_api_key
      raise Sportsdata::Exception, "golf_api_key is not configured" unless @golf_api_key
      @golf_api_key
    end

    def golf_images_api_key
      raise Sportsdata::Exception, "golf_images_api_key is not configured" unless @golf_images_api_key
      @golf_images_api_key
    end

    DEFAULT_LOG_LEVEL = 'info'

    def log_level
      @log_level || DEFAULT_LOG_LEVEL
    end

    def clean_state(state)
      return self.us_states[state] if self.us_states[state]
      return state
    end

    def us_states
        [
          ['Alabama', 'AL'],
          ['Alaska', 'AK'],
          ['Arizona', 'AZ'],
          ['Arkansas', 'AR'],
          ['California', 'CA'],
          ['Colorado', 'CO'],
          ['Connecticut', 'CT'],
          ['Delaware', 'DE'],
          ['District of Columbia', 'DC'],
          ['Florida', 'FL'],
          ['Georgia', 'GA'],
          ['Hawaii', 'HI'],
          ['Idaho', 'ID'],
          ['Illinois', 'IL'],
          ['Indiana', 'IN'],
          ['Iowa', 'IA'],
          ['Kansas', 'KS'],
          ['Kentucky', 'KY'],
          ['Louisiana', 'LA'],
          ['Maine', 'ME'],
          ['Maryland', 'MD'],
          ['Massachusetts', 'MA'],
          ['Michigan', 'MI'],
          ['Minnesota', 'MN'],
          ['Mississippi', 'MS'],
          ['Missouri', 'MO'],
          ['Montana', 'MT'],
          ['Nebraska', 'NE'],
          ['Nevada', 'NV'],
          ['New Hampshire', 'NH'],
          ['New Jersey', 'NJ'],
          ['New Mexico', 'NM'],
          ['New York', 'NY'],
          ['North Carolina', 'NC'],
          ['North Dakota', 'ND'],
          ['Ohio', 'OH'],
          ['Oklahoma', 'OK'],
          ['Oregon', 'OR'],
          ['Pennsylvania', 'PA'],
          ['Puerto Rico', 'PR'],
          ['Rhode Island', 'RI'],
          ['South Carolina', 'SC'],
          ['South Dakota', 'SD'],
          ['Tennessee', 'TN'],
          ['Texas', 'TX'],
          ['Utah', 'UT'],
          ['Vermont', 'VT'],
          ['Virginia', 'VA'],
          ['Washington', 'WA'],
          ['West Virginia', 'WV'],
          ['Wisconsin', 'WI'],
          ['Wyoming', 'WY']
        ]
    end
  end

  LIBRARY_PATH = File.join(File.dirname(__FILE__), 'sportsdata')
  autoload :Nfl,       File.join(LIBRARY_PATH, 'nfl')
  autoload :Nhl,       File.join(LIBRARY_PATH, 'nhl')
  autoload :Nba,       File.join(LIBRARY_PATH, 'nba')
  autoload :Mlb,       File.join(LIBRARY_PATH, 'mlb')
  autoload :Ncaafb,    File.join(LIBRARY_PATH, 'ncaafb')
  autoload :Ncaamb,    File.join(LIBRARY_PATH, 'ncaamb')
  autoload :Nascar,    File.join(LIBRARY_PATH, 'nascar')
  autoload :Golf,      File.join(LIBRARY_PATH, 'golf')
  autoload :Exception, File.join(LIBRARY_PATH, 'exception')
  autoload :Request,   File.join(LIBRARY_PATH, 'request')
end
