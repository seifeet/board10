class AppFormBuilder < ActionView::Helpers::FormBuilder
  def submit_button(text, options = {})
    options[:type] = "submit"
    @template.content_tag(:button, text, options)
  end  
end