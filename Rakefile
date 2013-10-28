# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'yaml'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

desc "Open an irb session preloaded with this library"
task :console do

  dev = File.join('config.yml')
  config_string = ''
  YAML.load(File.open(dev)).each do |key, value|
    config_string += "#{key}=#{value} "
  end if File.exists?(dev)
  sh "#{config_string} irb -rubygems -I lib -r sportsdata_console.rb"
end

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "sportsdata"
  gem.homepage = "http://github.com/miamiruby/sportsdata"
  gem.license = "MIT"
  gem.summary = %Q{Sports Data}
  gem.description = %Q{Fetch Data from sportsdatainc.com}
  gem.email = "paul@miamiphp.org"
  gem.authors = ["Paul Kruger", "Aldo Delgado", "Moises Zaragoza"]
  gem.files.include 'lib/**/*'
end

Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sportsdata #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
