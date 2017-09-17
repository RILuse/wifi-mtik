module ApplicationHelper
  def errors_for(object)
    if object.errors.any?
      content_tag(:div, class: "panel panel-danger") do
        concat(content_tag(:div, class: "panel-heading") do
          concat(content_tag(:h4, class: "panel-title") do
            #concat "#{pluralize(object.errors.count, "")} Возникли проблемы:"
            concat "Возникли проблемы:"
          end)
        end)
        concat(content_tag(:div, class: "panel-body alert-danger") do
          concat(content_tag(:ul) do
            object.errors.full_messages.each do |msg|
              concat content_tag(:li, msg)
            end
          end)
        end)
      end
    end
  end

  def errors_for_input(model, attribute)
    if model.errors[attribute].present?
      content_tag :span, :class => 'help-block' do
        model.errors[attribute].join(", ")
      end
    end
  end

  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success"   # Green
      when "error"
        "alert-danger"    # Red
      when "alert"
        "alert-warning"   # Yellow
      when "notice"
        "alert-info"      # Blue
      else
        flash_type.to_s
    end
  end
end
