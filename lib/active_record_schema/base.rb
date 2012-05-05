require 'active_record_schema/dsl'

module ActiveRecordSchema
  module Base
    extend ActiveSupport::Concern
    include ActiveRecordSchema::Dsl
  end
end
