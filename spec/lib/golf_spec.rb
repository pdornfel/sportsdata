require 'spec_helper'

describe Sportsdata::Golf, vcr: {
    cassette_name: 'sportsdata_golf',
    record: :new_episodes,
    match_requests_on: [:uri]
  } do

 context 'no response from the api' do
   before(:each) {
     stub_request(:any, /api\.sportsdatallc\.org.*/).to_timeout
   }

   describe '.player_profiles' do
     it {expect { subject.player_profiles }.to raise_error(Sportsdata::Exception) }
   end

   describe '.seasonal_stats' do
    it { expect { subject.seasonal_stats }.to raise_error(Sportsdata::Exception) }
   end

   describe '.tournament_schedule' do
     it { expect { subject.tournament_schedule }.to raise_error(Sportsdata::Exception) }
   end

 end
end
