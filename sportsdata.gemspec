# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sportsdata"
  s.version = "1.17.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Kruger", "Moises Zaragoza", "Aldo Delgado"]
  s.date = "2013-11-14"
  s.description = "Fetch Data from sportsdatainc.com"
  s.email = "paul@miamiphp.org"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".ruby-gemset",
    ".ruby-version",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "config.example.yml",
    "lib/sportsdata.rb",
    "lib/sportsdata/exception.rb",
    "lib/sportsdata/golf.rb",
    "lib/sportsdata/mlb.rb",
    "lib/sportsdata/nascar.rb",
    "lib/sportsdata/nba.rb",
    "lib/sportsdata/ncaafb.rb",
    "lib/sportsdata/ncaamb.rb",
    "lib/sportsdata/nfl.rb",
    "lib/sportsdata/nhl.rb",
    "lib/sportsdata/request.rb",
    "lib/sportsdata_console.rb",
    "spec/cassettes/sportsdata_nfl.yml",
    "spec/lib/mlb_spec.rb",
    "spec/lib/nba_spec.rb",
    "spec/lib/nfl_spec.rb",
    "spec/lib/nhl_spec.rb",
    "spec/spec_helper.rb",
    "spec/sportsdata_spec.rb",
    "sportsdata.gemspec"
  ]
  s.homepage = "http://github.com/miamiruby/sportsdata"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.6"
  s.summary = "Sports Data"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<faraday>, [">= 0"])
      s.add_runtime_dependency(%q<faraday_middleware>, [">= 0"])
      s.add_runtime_dependency(%q<multi_xml>, [">= 0"])
      s.add_runtime_dependency(%q<hashie>, [">= 0"])
      s.add_development_dependency(%q<awesome_print>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3.5"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.7"])
      s.add_development_dependency(%q<debugger>, [">= 0"])
      s.add_development_dependency(%q<vcr>, [">= 0"])
      s.add_development_dependency(%q<webmock>, ["~> 1.9.0"])
      s.add_development_dependency(%q<travis>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<faraday>, [">= 0"])
      s.add_dependency(%q<faraday_middleware>, [">= 0"])
      s.add_dependency(%q<multi_xml>, [">= 0"])
      s.add_dependency(%q<hashie>, [">= 0"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 4.0.0"])
      s.add_dependency(%q<bundler>, ["~> 1.3.5"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.7"])
      s.add_dependency(%q<debugger>, [">= 0"])
      s.add_dependency(%q<vcr>, [">= 0"])
      s.add_dependency(%q<webmock>, ["~> 1.9.0"])
      s.add_dependency(%q<travis>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<faraday>, [">= 0"])
    s.add_dependency(%q<faraday_middleware>, [">= 0"])
    s.add_dependency(%q<multi_xml>, [">= 0"])
    s.add_dependency(%q<hashie>, [">= 0"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 4.0.0"])
    s.add_dependency(%q<bundler>, ["~> 1.3.5"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.7"])
    s.add_dependency(%q<debugger>, [">= 0"])
    s.add_dependency(%q<vcr>, [">= 0"])
    s.add_dependency(%q<webmock>, ["~> 1.9.0"])
    s.add_dependency(%q<travis>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end

