module  ActiveRecordSchema
  module SchemaDiff
    extend ActiveSupport::Concern

    def diff(*args)
      diff_method = "_diff_" << args.join('_')
      self.respond_to?(diff_method) ? self.send(diff_method) : []
    end
    
    def _diff_fields_add
      model.schema.fields.values.delete_if {|f| _column_names.include?(f.name.to_s) }
    end

    def _diff_indexes_add
      model.schema.indexes.values.delete_if {|f| _index_names.include?(f.name.to_s) }
    end

    def _connection
      ActiveRecord::Base.connection
    end
    
    def _table
      model.table_name
    end
    
    def _column_names
      _connection.columns(_table).map(&:name)
    end
    
    def _index_names
      _connection.indexes(_table).map(&:name)      
    end

  end
end