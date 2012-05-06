module ActiveRecordSchema
  class Join
    attr_reader :table, :key1, :key2, :index
    def initialize(table, key1, key2, index = true)
      @table = table
      @key1 = key1
      @key2 = key2
      @index = index
    end
  end
end