require 'active_record_schema/schema'

module ActiveRecordSchema
  module Dsl
    extend ActiveSupport::Concern
    module ClassMethods
     
      def schema    
        if self.superclass != ActiveRecord::Base
          table_holder = self.ancestors.find {|c| c.is_a?(Class) && c.superclass == ActiveRecord::Base}
          table_holder.schema
        else
          @active_record_schema_schema ||= ActiveRecordSchema::Schema.new(self)
        end
      end # ~ schema
          
       # field :name, :string, :default => "Joe"      
       def field(name, *args)
         options    = args.extract_options!
         type       = options.delete(:as) || options.delete(:type) || args.first || :string
         type       = type.name.underscore.to_sym if (type.class == Class) 
         index      = options.delete(:index)
  
         schema.add_field(name, type, options)

         if index
           schema.add_index(name)
         end       
       end
    
       def belongs_to(name, options = {})
         options.symbolize_keys!
         skip_index = options.delete(:index) == false
      
         foreign_key  = options[:foreign_key] || "#{name}_id"
         field :"#{foreign_key}", :integer
      
         if options[:polymorphic]
           foreign_type = options[:foreign_type] || "#{name}_type"
           field :"#{foreign_type}"
           add_index [:"#{foreign_key}", :"#{foreign_type}"] if !skip_index
         else
           add_index :"#{foreign_key}" if !skip_index
         end
      
         super(name, options)
       end
    
       def has_and_belongs_to_many(name, options = {}, &extension)
         options.symbolize_keys!

         self_class_name = self.name
         association_class_name = options[:class_name] || "#{name}".singularize.camelize

         table = options[:join_table] || [self_class_name, association_class_name].sort.map(&:tableize).join("_")
         key1  = options[:foreign_key] || "#{self_class_name.underscore}_id"
         key2  = options[:association_foreign_key] || "#{association_class_name.underscore}_id"
         skip_index = options.delete(:index) == false

         schema.add_join(table, key1, key2, !skip_index)
         super(name, options, &extension)
       end
            
       def index(column_name, options = {})
         schema.add_index(column_name, options)
       end
       alias :add_index :index
      
       def timestamps
         field :created_at, :datetime
         field :updated_at, :datetime
       end
     
       def inheritable
         field :"#{inheritance_column}"
       end
     
    end

  end
end
