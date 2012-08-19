require 'active_record_schema/field'
require 'active_record_schema/index'
require 'active_record_schema/join'
require 'active_record_schema/schema_diff'

module ActiveRecordSchema
  class Schema
    include ActiveRecordSchema::SchemaDiff

    attr_reader :model, :fields, :indexes, :joins
    
    def initialize(model)
      @model   = model
      @fields  = ActiveSupport::OrderedHash.new
      @indexes = {}
      @joins   = {}
    end
    
    def hierarchy_fields
      if @hierarchy_fields
        @hierarchy_fields
      else
        @hierarchy_fields ||= ActiveSupport::OrderedHash.new
        model.ancestors.select { |c| c < ActiveRecord::Base }.reverse_each do |klass|
          @hierarchy_fields = @hierarchy_fields.merge(klass.schema.fields)
        end
        @hierarchy_fields  
      end
    end
    
    def hierarchy_field_names
      hierarchy_fields.values.map(&:name).map(&:to_s)
    end

    def field_names
      fields.values.map(&:name).map(&:to_s)
    end
    
    def add_field(column, type, options)
      @fields[:"#{column}"]  = Field.new(column, type, options)
    end

    def add_index(column, options = {})
      @indexes[:"#{column}"] = Index.new(column, options)
    end
    
    def add_join(table, key1, key2, index = true)
      @joins[:"#{table}"] = Join.new(table, key1, key2) 
    end
    
  end
end