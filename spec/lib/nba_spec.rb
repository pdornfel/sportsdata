require 'spec_helper'

describe Sportsdata::Nba, vcr: {
    cassette_name: 'sportsdata_nba',
    record: :new_episodes,
    match_requests_on: [:uri]
  } do

 context 'no response from the api' do
   before(:each) {
     stub_request(:any, /api\.sportsdatallc\.org.*/).to_timeout
   }

   describe '.venues' do
     it {expect { subject.venues }.to raise_error(Sportsdata::Exception) }
   end

   describe '.teams' do
    it { expect { subject.teams }.to raise_error(Sportsdata::Exception) }
   end

   describe '.games' do
     it { expect { subject.games }.to raise_error(Sportsdata::Exception) }
   end

   describe '.players' do
     it { expect { subject.players }.to raise_error(Sportsdata::Exception) }
   end

 end
end
