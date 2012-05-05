require 'active_record_schema/field'
require 'active_record_schema/index'
require 'active_record_schema/schema_diff'

module ActiveRecordSchema
  class Schema
    include ActiveRecordSchema::SchemaDiff

    attr_reader :model, :fields, :indexes, :options
    delegate :has_one, :has_many, :has_and_belongs_to_many, :to => :model
      
    def initialize(model, options)
      @model   = model
      @fields  = {}
      @indexes = {}
      @options = options.symbolize_keys
    end

    def field_names
      fields.values.map(&:name).map(&:to_s)
    end

    # field :name, :string, :default => "Joe"      
    def field(name, *args)
      options    = args.extract_options!
      type       =  options.delete(:as) || options.delete(:type) || args.first || :string
      type       = type.name.tableize.to_sym if (type.class == Class) 
      index      = options.delete(:index)
  
      _add_field(name, type, options)

      if index
        _add_index(name)
      end       
    end
    alias :key       :field
    alias :property  :field
    alias :col       :field
    
    def belongs_to(name, options = {})
      options.symbolize_keys!
      skip_index = options.delete(:index) == false
      
      foreign_key  = options[:foreign_key] || "#{name}_id"
      field :"#{foreign_key}"
      
      if opts[:polimorphic]
        foreign_type = options[:foreign_type] || "#{name}_type"
        field :"#{foreign_type}"
        add_index [:foreign_key, :foreign_type] if !skip_index
      else
        add_index :foreign_key if !skip_index
      end
      
      model.send(:belongs_to, name, options)
    end
            
    def add_index(column_name, options = {})
      _add_index(column_name, options)
    end
    alias :index :add_index

    def inheritable!
      field :"#{model.inheritance_column}"
    end
    alias :inheritable :inheritable!
      
    def timestamps!
      field :created_at, :datetime
      field :updated_at, :datetime
    end
    alias :timestamps :timestamps!
    
    private
    
    def _add_field(column, type, options)
      @fields[:"#{column}"]  = Field.new(column, type, options)
    end

    def _add_index(column, options = {})
      @indexes[:"#{column}"] = Index.new(column, options)
    end
    
  end
end