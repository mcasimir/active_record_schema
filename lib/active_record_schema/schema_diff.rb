module  ActiveRecordSchema
  module SchemaDiff
    extend ActiveSupport::Concern

    def diff(*args)
      diff_method = "_diff_" << args.join('_')
      self.respond_to?(diff_method) ? self.send(diff_method) : []
    end
    
    def nothing_to_do?
      table_exists? && diff(:fields, :add).empty? && diff(:indexes, :add).empty? && diff(:joins, :add).empty? 
    end
    
    def table_exists?
      _table_exists?
    end
    
    def _diff_fields_add
      model.schema.fields.values.delete_if {|field| _column_names.include?(field.name.to_s) }
    end

    def _diff_indexes_add
      model.schema.indexes.values.delete_if {|index| _index_names.include?(index.name.to_s) }
    end

    def _diff_joins_add
      model.schema.joins.values.delete_if {|join| _table_names.include?(join.table.to_s) }
    end
    
    def _connection
      ActiveRecord::Base.connection
    end
    
    def _table
      model.table_name
    end
    
    def _column_names
      _table_exists? ? _connection.columns(_table).map(&:name) : []
    end
    
    def _index_names
      _table_exists? ? _connection.indexes(_table).map(&:name) : []
    end
    
    def _table_names
      _connection.tables
    end
    
    def _table_exists?
      _connection.table_exists?(_table)
    end

  end
end