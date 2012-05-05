module ActiveRecordSchema
  class Railtie < Rails::Railtie
    config.app_generators.orm :active_record_schema
  end
end