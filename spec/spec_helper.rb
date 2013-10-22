$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'yaml'
require 'ruby-debug'
require 'sportsdata'
require 'webmock/rspec'
require 'vcr'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  dev = File.join('config.yml')
  YAML.load(File.open(dev)).each do |key, value|
    ENV[key.to_s] = value
  end if File.exists?(dev)
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.preserve_exact_body_bytes { true }
  c.configure_rspec_metadata!
  ##
  # Filter the real API key so that it does not make its way into the VCR cassette
  #dev = File.join('config.yml')
  #YAML.load(File.open(dev)).each do |key, value|
  #  c.filter_sensitive_data("<#{key}>")  { value }
  #end if File.exists?(dev)
end
