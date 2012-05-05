require 'rails'
require 'ostruct'

module ActiveRecordSchema
  
  def config
    @config ||= OpenStruct.new
    @config.autoload_paths ||= [
       Rails.root.join('app', 'models', '*.rb'),
       Rails.root.join('app', 'models', '**', '*.rb') 
    ]
    @config
  end
  module_function :config
  
  def autoload_paths
    config.autoload_paths.map {|p| Dir.glob(p) }.flatten! 
  end
  module_function :autoload_paths

end

require 'active_record_schema/base'
require 'active_record_schema/railtie'

ActiveRecord::Base.send(:include, ActiveRecordSchema::Base)
