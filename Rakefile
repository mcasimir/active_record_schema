# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "active_record_schema"
  gem.homepage = "http://github.com/mcasimir/active_record_schema"
  gem.license = "MIT"
  gem.summary = %Q{ActiveRecord extension allowing to write schema in models and to generate migrations from models}
  gem.description = %Q{ActiveRecordSchema is an ActiveRecord extension that allows you to write the database schema for a model within the model itself and to generate migrations directly from models.}
  gem.email = "maurizio.cas@gmail.com"
  gem.authors = ["mcasimir"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new


