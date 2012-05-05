require 'active_record_schema/schema'

module ActiveRecordSchema
  module Dsl
    extend ActiveSupport::Concern
    module ClassMethods
      
      def schema(*args, &block)        
        if self.superclass != ActiveRecord::Base
          table_holder = self.ancestors.find {|c| c.is_a?(Class) && c.superclass == ActiveRecord::Base}
          table_holder.schema(*args, &block)
        else
          options = args.extract_options!
        
          if block_given?
            @active_record_schema_schema ||= ActiveRecordSchema::Schema.new(self, options)
            @active_record_schema_schema.instance_eval(&block)
            if options[:inheritable]
              @active_record_schema_schema.inheritable!
            end
            @active_record_schema_schema
          else
            @active_record_schema_schema
          end
        end
     end # ~ schema
      
    end

  end
end
