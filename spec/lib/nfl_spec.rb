require 'spec_helper'

describe Sportsdata::Nfl, vcr: {
    cassette_name: 'sportsdata_nfl',
    record: :new_episodes,
    match_requests_on: [:uri]
  } do

#describe Sportsdata::Nfl do

 context 'no response from the api' do
   before(:each) {
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
     stub_request(:any, /api\.sportsdatallc\.org.*/).to_timeout
   }

   describe '.venues' do
     it {expect { subject.venues }.to raise_error(Sportsdata::Exception) }
   end

   describe '.teams' do
    it { expect { subject.teams }.to raise_error(Sportsdata::Exception) }
   end

   describe '.players' do
     it { expect { subject.players }.to raise_error(Sportsdata::Exception) }
   end

   describe '.games' do
     it { expect { subject.games }.to raise_error(Sportsdata::Exception) }
   end

   describe '.schedules' do
     it { expect { subject.schedules }.to raise_error(Sportsdata::Exception) }
   end
 end

# context 'create valid URLs' do
#   let(:venues_url) { 'teams/hierarchy.xml' }
#   #let(:venues_url) { 'teams/hierarchy.xml' }
#   #let(:teams_url) { 'http://api.sportsdatallc.org/nfl-t1/teams/hierarchy.xml' }
#   before(:each) do
#     Sportsdata.configure do |config|
#       config.nfl_api_key = ENV['NFL_API_KEY']
#       config.nhl_api_key = ENV['NHL_API_KEY']
#       config.nba_api_key = ENV['NBA_API_KEY']
#       config.mlb_api_key = ENV['MLB_API_KEY']
#       config.ncaafb_api_key = ENV['NCAAFB_API_KEY']
#       config.ncaamb_api_key = ENV['NCAAMB_API_KEY']
#       config.nascar_api_key = ENV['NASCAR_API_KEY']
#       config.golf_api_key = ENV['GOLF_API_KEY']
#       config.api_mode = ENV['API_MODE']
#     end
#     @venues_xml = Sportsdata.nfl.get_raw("#{venues_url}")
#     #@teams_xml = Faraday.new.get("#{teams_url}?api_key=#{Sportsdata.nfl_api_key}")
#   end
#
#    describe '.venues' do
#      it 'creates a valid Sportsdata api url' do
#        params = { api_key: Sportsdata.nfl_api_key }
#        subject.should_receive(:get_raw).with(venues_url).and_yield(@venues_xml)
#        #subject.venues_url.should == venues_url
#        debugger
#        subject.venues
#      end
#    end
#
#    #describe '.teams' do
#      #it 'creates a valid Sportsdata api url' do
#      #  params = { params: { api_key: Sportsdata.nfl_api_key } }
#      #  Faraday.should_receive(:get).with(teams_url, params).and_yield(@teams_xml)
#      #  Faraday.should_receive(:get).with(teams_url, params).and_return(@teams_xml)
#      #  subject.teams
#      #end
#    #end
#
#  end
end
