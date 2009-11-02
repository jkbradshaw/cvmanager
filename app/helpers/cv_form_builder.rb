class CvFormBuilder < ActionView::Helpers::FormBuilder
  def self.create_labeled_field(method_name)
    define_method(method_name) do |label, *args|
      options = {}
      options = args.last if args.last.class == Hash
      field_label = options[:label] || label
      @template.content_tag("p", 
        @template.content_tag("label",field_label.to_s.humanize, :for=>"#{@object_name}_#{label}") + 
        super )
    end          
  end
  
  %w[text_field password_field text_area select].each do |name|
    create_labeled_field(name)
  end
  
  def begin_form(options = {})
    error_messages + "<fieldset><legend>#{options[:legend]}</legend>"
  end
  
  def end_form
    form_buttons + "</fieldset>"
  end
  
  def form_buttons
    "<div class='prepend-14'>" + 
    "<input type='submit' value='Submit' name='submit' class='fg-button ui-state-default ui-corner-all' ></input>" +
    "<input type='submit' value='Cancel' name='cancel' class='fg-button ui-state-default ui-corner-all' ></input>" +
    "</div>"
  end
  
end