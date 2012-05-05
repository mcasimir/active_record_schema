require 'generators/active_record_schema'

module ActiveRecordSchema
  module Generators
    class ModelGenerator < Base
      class_option :in, :type => :string
      class_option :inherit, :type => :string, :default => 'ActiveRecord::Base'
      class_option :from

      def create_model_file
        create_file ["app", "models", subdir, "#{file_name}.rb"].compact.join('/'), <<-FILE
    class #{class_name} < #{ inherit }
    end
        FILE
      end
  
      private

      def subdir
        in_opt = "#{options[:in]}".strip
        in_opt.empty? || in_opt.match(/\//) ? nil : in_opt
      end
  
      def inherit
        options[:inherit]
      end
      
      
    end
  end
end

