module ActiveRecordSchema
  class Field
    attr_reader :name, :type, :options
    def initialize(name, type, options = {})
      @name = name
      @type = type
      @options = options
    end
  end
end
