require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Sportsdata do
  it "should respond to configure" do
    subject.respond_to?(:configure).should be
  end

  context "Sports Data Config" do
    it "should be able to configure api keys and mode" do
        subject.nfl_api_key.should == ENV['SPORTSDATA_NFL_API_KEY']
        subject.nfl.api_key.should == ENV['SPORTSDATA_NFL_API_KEY']
        subject.nhl_api_key.should == ENV['SPORTSDATA_NNHL_API_KEY']
        subject.nhl.api_key.should == ENV['SPORTSDATA_NNHL_API_KEY']
        subject.nba_api_key.should == ENV['SPORTSDATA_NNBA_API_KEY']
        subject.nba.api_key.should == ENV['SPORTSDATA_NNBA_API_KEY']
        subject.mlb_api_key.should == ENV['SPORTSDATA_MMLB_API_KEY']
        subject.mlb.api_key.should == ENV['SPORTSDATA_MMLB_API_KEY']
        subject.ncaafb_api_key.should == ENV['SPORTSDATA_NCAAFB_API_KEY']
        subject.ncaafb.api_key.should == ENV['SPORTSDATA_NCAAFB_API_KEY']
        subject.ncaamb_api_key.should == ENV['SPORTSDATA_NCAAMB_API_KEY']
        subject.ncaamb.api_key.should == ENV['SPORTSDATA_NCAAMB_API_KEY']
        subject.nascar_api_key.should == ENV['SPORTSDATA_NASCAR_API_KEY']
        subject.nascar.api_key.should == ENV['SPORTSDATA_NASCAR_API_KEY']
        subject.golf_api_key.should == ENV['SPORTSDATA_GOLF_API_KEY']
        subject.golf.api_key.should == ENV['SPORTSDATA_GOLF_API_KEY']
        subject.api_mode.should == ENV['SPORTSDATA_API_MODE']
    end
  end
end
