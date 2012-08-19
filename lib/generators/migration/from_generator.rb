require "rails/generators/migration"
require "active_record/migration"

# rails g migration:from post link blog photo
# rails g migration:from post --add name address

module Migration
  class FromGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    
    include Rails::Generators::Migration
    class << self
      def next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end
    end
    
    
    argument :model_names, :type => :array, :default => [], :banner => "model model"
    class_option :add, :type => :array, :default => [], :banner => "attrname attrname"

    def preload_models
      ActiveRecordSchema.autoload_paths.each do |p|
        load(p)
      end
      
    end
    
    def create_migrations
      models.each do |current_model|
        @current_model = current_model
        migration_file_name = "#{migration_prefix}_#{current_model.name.underscore.gsub('::', '_').pluralize}"
        migration_template "migration_from_model.rb.erb", "db/migrate/#{migration_file_name}.rb"
      end
    end
    
    protected

    def model
      @current_model
    end
    
    def inherits?
      model.superclass < ActiveRecord::Base
    end
       
    def models
      @models ||= model_names.map {|name|
        name.singularize.camelize.constantize
      } 
    end
    
    def migration_prefix
      if options[:add].any?
        "add_#{options[:add].join('_and_')}_to"
      else
        "create"
      end      
    end
        
  end
end
