require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Sportsdata do
  it "should respond to configure" do
    subject.respond_to?(:configure).should be
  end

  context "Sports Data Config" do
    before do
      Sportsdata.configure do |config|
        config.nfl_api_key = 'nfl'
        config.nhl_api_key = 'nhl'
        config.nba_api_key = 'nba'
        config.mlb_api_key = 'mlb'
        config.ncaafb_api_key = 'ncaafb'
        config.ncaamb_api_key = 'ncaamb'
        config.api_mode = 'rt'
      end
    end
    it "should be able to configure api keys and mode" do
      subject.nfl_api_key.should == 'nfl'
      subject.nfl.api_key.should == 'nfl'
      subject.nhl_api_key.should == 'nhl'
      subject.nhl.api_key.should == 'nhl'
      subject.nba_api_key.should == 'nba'
      subject.nba.api_key.should == 'nba'
      subject.mlb_api_key.should == 'mlb'
      subject.mlb.api_key.should == 'mlb'
      subject.ncaafb_api_key.should == 'ncaafb'
      subject.ncaafb.api_key.should == 'ncaafb'
      subject.ncaamb_api_key.should == 'ncaamb'
      subject.ncaamb.api_key.should == 'ncaamb'
      subject.api_mode.should == 'rt'
    end
  end
end
