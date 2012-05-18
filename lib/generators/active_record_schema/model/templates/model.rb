<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
<% if options[:inheritable]-%>
  inheritable
<% end %>
<% attributes.each do |attribute| -%>
  field :<%= attribute.name %>, :<%= attribute.type %><%= attribute.inject_options %>
<% end -%>
<% if options[:timestamps] %>
  timestamps
<% end -%>
<% attributes.select {|attr| attr.reference? }.each do |attribute| -%>
  belongs_to :<%= attribute.name %>
<% end -%>
<% if !accessible_attributes.empty? -%>
  attr_accessible <%= accessible_attributes.map {|a| ":#{a.name}" }.sort.join(', ') %>
<% else -%>
  # attr_accessible :title, :body
<% end -%>
end
<% end -%>





