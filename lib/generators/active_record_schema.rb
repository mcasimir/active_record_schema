require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_model'

module ActiveRecordSchema
  module Generators
    class Base < ::Rails::Generators::NamedBase
    
      include Rails::Generators::Migration

      def self.base_root
        File.dirname(__FILE__)
      end

      def self.next_migration_number(dirname) #:nodoc:
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end
    
    end
  end
end