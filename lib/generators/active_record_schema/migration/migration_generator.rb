require 'generators/active_record_schema'

module ActiveRecordSchema
  module Generators
    class MigrationGenerator < Base
      source_root File.expand_path('../templates', __FILE__)
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      class_option :from, :type => :string, :desc => "calculates the changes to be applied on model table from the schema defined inside the model itself"
      class_option :id, :type => :numeric, :desc => "The id to be used in this migration"

       def create_migration_file
         set_local_assigns!
         if options[:from]
           # preload every model
           ActiveRecordSchema.autoload_paths.each do |p|
             load(p)
           end
           
           migration_template "migration_from_model.rb.erb", "db/migrate/#{file_name}.rb"
         else
           migration_template "migration.rb", "db/migrate/#{file_name}.rb"
         end
       end
       
       protected


       def model
         @model ||= if !!options[:from]
           options[:from].constantize
         else
           false
         end
       end
       
       attr_reader :migration_action

       def set_local_assigns!
         if file_name =~ /^(add|remove|drop)_.*_(?:to|from)_(.*)/
           @migration_action = $1 == 'add' ? 'add' : 'drop'
           @table_name       = $2.pluralize
         end
       end

      
    end
  end
end

