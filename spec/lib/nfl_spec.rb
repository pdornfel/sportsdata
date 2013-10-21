require 'spec_helper'

#describe SportsDataApi::Nfl, vcr: {
#    cassette_name: 'sports_data_api_nfl',
#    record: :new_episodes,
#    match_requests_on: [:uri]
#} do

describe Sportsdata::Nfl do

  context 'no response from the api' do
    before(:each) {
      Sportsdata.configure do |config|
        config.nfl_api_key = 'nfl'
        config.nhl_api_key = 'nhl'
        config.nba_api_key = 'nba'
        config.mlb_api_key = 'mlb'
        config.ncaafb_api_key = 'ncaafb'
        config.ncaamb_api_key = 'ncaamb'
        config.api_mode = 'rt'
      end
      stub_request(:any, /api\.sportsdatallc\.org.*/).to_timeout
    }

    describe '.venues' do
      it {
        expect {
          subject.venues
        }.to raise_error(Sportsdata::Exception)
      }
    end

    describe '.teams' do
      it {
        expect {
          subject.teams
        }.to raise_error(Sportsdata::Exception)
      }
    end
    describe '.players' do
      it {
        expect {
          subject.players
        }.to raise_error(Sportsdata::Exception)
      }
    end
    describe '.games' do
      it {
        expect {
          subject.games
        }.to raise_error(Sportsdata::Exception)
      }
    end
    describe '.schedules' do
      it {
        expect {
          subject.schedules
        }.to raise_error(Sportsdata::Exception)
      }
    end
  end

  # context 'create valid URLs' do
  #   let(:schedule_url) {
  #     'http://api.sportsdatallc.org/nfl-t1/2012/REG/schedule.xml'
  #     'http://api.sportsdatallc.org/nfl-t1/teams/hierarchy.xml?api_key=x69q65ye8dpps7f547nm5ahv'
  #   }
  #
  #   let(:boxscore_url) {
  #     'http://api.sportsdatallc.org/nfl-t1/2012/REG/9/MIA/IND/boxscore.xml'
  #   }
  #
  #   before(:each) do
  #     SportsDataApi.key = 'invalid_key'
  #     SportsDataApi.access_level = 't'
  #     @schedule_xml = RestClient.get("#{schedule_url}?api_key=#{api_key}")
  #     @boxscore_xml = RestClient.get("#{boxscore_url}?api_key=#{api_key}")
  #   end
  #
  #   describe '.schedule' do
  #     it 'creates a valid Sports Data LLC url' do
  #       params = { params: { api_key: SportsDataApi.key } }
  #       RestClient.should_receive(:get).with(schedule_url, params).and_return(@schedule_xml)
  #       subject.schedule(2012, :REG)
  #     end
  #   end
  #
  #   describe '.boxscore' do
  #     it 'creates a valid Sports Data LLC url' do
  #       params = { params: { api_key: SportsDataApi.key } }
  #       RestClient.should_receive(:get).with(boxscore_url, params).and_return(@boxscore_xml)
  #       subject.boxscore(2012, :REG, 9, 'IND', 'MIA')
  #     end
  #   end
  # end
end
