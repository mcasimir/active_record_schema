require 'generators/active_record_schema'

module ActiveRecordSchema
  module Generators
    class ModelGenerator < Base

      argument :attributes, :type => :array, :default => [], :banner => "field[:type][:index] field[:type][:index]"

      check_class_collision

      class_option :inheritable, :type => :boolean, :desc => "Add 'inheritable' to the generated model"
      class_option :timestamps,  :type => :boolean, :desc => "Add 'timestamps' to the generated model"
      class_option :scope,       :type => :string,  :desc => "The subpath of app/models in which model file will be created"
      class_option :parent,      :type => :string,  :desc => "The parent class for the generated model"

      def create_model_file
        template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
      end

      def create_module_file
        return if regular_class_path.empty?
        scope_path = ["app", "models", subdir].compact.join('/')
        template 'module.rb', File.join(scope_path, "#{class_path.join('/')}.rb") if behavior == :invoke
      end

      def attributes_with_index
        attributes.select { |a| a.has_index? || (a.reference? && options[:indexes]) }
      end

      def accessible_attributes
        attributes.reject(&:reference?)
      end

      hook_for :test_framework

      protected

      def subdir
        in_opt = "#{options[:in]}".strip
        in_opt.empty? || in_opt.match(/\//) ? nil : in_opt
      end

      def parent_class_name
        options[:parent] || "ActiveRecord::Base"
      end

    end
  end
end