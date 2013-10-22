require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Sportsdata do
  it "should respond to configure" do
    subject.respond_to?(:configure).should be
  end

  context "Sports Data Config" do
    before do
      Sportsdata.configure do |config|
        config.nfl_api_key = ENV['NFL_API_KEY']
        config.nhl_api_key = ENV['NHL_API_KEY']
        config.nba_api_key = ENV['NBA_API_KEY']
        config.mlb_api_key = ENV['MLB_API_KEY']
        config.ncaafb_api_key = ENV['NCAAFB_API_KEY']
        config.ncaamb_api_key = ENV['NCAAMB_API_KEY']
        config.nascar_api_key = ENV['NASCAR_API_KEY']
        config.golf_api_key = ENV['GOLF_API_KEY']
        config.api_mode = ENV['API_MODE']
      end
    end
    it "should be able to configure api keys and mode" do
        subject.nfl_api_key.should == ENV['NFL_API_KEY']
        subject.nfl.api_key.should == ENV['NFL_API_KEY']
        subject.nhl_api_key.should == ENV['NHL_API_KEY']
        subject.nhl.api_key.should == ENV['NHL_API_KEY']
        subject.nba_api_key.should == ENV['NBA_API_KEY']
        subject.nba.api_key.should == ENV['NBA_API_KEY']
        subject.mlb_api_key.should == ENV['MLB_API_KEY']
        subject.mlb.api_key.should == ENV['MLB_API_KEY']
        subject.ncaafb_api_key.should == ENV['NCAAFB_API_KEY']
        subject.ncaafb.api_key.should == ENV['NCAAFB_API_KEY']
        subject.ncaamb_api_key.should == ENV['NCAAMB_API_KEY']
        subject.ncaamb.api_key.should == ENV['NCAAMB_API_KEY']
        subject.nascar_api_key.should == ENV['NASCAR_API_KEY']
        subject.nascar.api_key.should == ENV['NASCAR_API_KEY']
        subject.golf_api_key.should == ENV['GOLF_API_KEY']
        subject.golf.api_key.should == ENV['GOLF_API_KEY']
        subject.api_mode.should == ENV['API_MODE']
    end
  end
end
