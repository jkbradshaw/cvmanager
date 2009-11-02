

class TableFormBuilder < ActionView::Helpers::FormBuilder
  def self.create_labeled_field(method_name)
    define_method(method_name) do |label, *args|
      options = {}
      options = args.last if args.last.class == Hash
      field_label = options[:label] || label
      @template.content_tag("tr",
        @template.content_tag("td",
          @template.content_tag("label", field_label.to_s.humanize, :for=> "#{@object_name}_#{label}")) +
        @template.content_tag("td", super))
    end          
  end
  
  (field_helpers - %w(hidden_field fields_for error_messages)).each do |name|
    create_labeled_field(name)
  end
  
  def begin_form(options = {})
    error_messages + "<fieldset><legend>#{options[:legend]}</legend>" + 
    "<table><tr><td class='span-10'></td><td class='span-48'></td><td class='span-25'></td>"
  end
  
  def end_form
    "</table></fieldset>" + form_buttons
  end
  
  def form_buttons
    "<div class='prepend-12'>" + 
    "<input type='submit' value='Submit' class='fg-button ui-state-default ui-corner-all' ></input>" +
    "<input type='submit' value='Cancel' name='cancel' class='fg-button ui-state-default ui-corner-all' ></input>" +
    "</div>"
  end
end