class ModelGenerator < ::Rails::Generators::NamedBase
  
  def create_model_file
    create_file "app/models/#{file_name}.rb"  do
<<-eos
class #{class_name} < ActiveRecord::Base

end

eos
      
    end
  end
  
  protected
  
  def class_name
    name.camelize
  end
  
  def file_name
    name.underscore
  end
  
end
