# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "active_record_schema"
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["mcasimir"]
  s.date = "2012-05-07"
  s.description = "ActiveRecordSchema is an ActiveRecord extension that allows you to write the database schema for a model within the model itself and to generate migrations directly from models."
  s.email = "maurizio.cas@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "active_record_schema.gemspec",
    "lib/active_record_schema.rb",
    "lib/active_record_schema/base.rb",
    "lib/active_record_schema/dsl.rb",
    "lib/active_record_schema/field.rb",
    "lib/active_record_schema/index.rb",
    "lib/active_record_schema/join.rb",
    "lib/active_record_schema/railtie.rb",
    "lib/active_record_schema/schema.rb",
    "lib/active_record_schema/schema_diff.rb",
    "lib/generators/active_record_schema.rb",
    "lib/generators/active_record_schema/migration/migration_generator.rb",
    "lib/generators/active_record_schema/migration/templates/migration.rb",
    "lib/generators/active_record_schema/migration/templates/migration_from_model.rb.erb",
    "lib/generators/active_record_schema/model/model_generator.rb"
  ]
  s.homepage = "http://github.com/mcasimir/active_record_schema"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "ActiveRecord extension allowing to write schema in models and to generate migrations from models"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
    else
      s.add_dependency(%q<rails>, ["~> 3.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
  end
end

