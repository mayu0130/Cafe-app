module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then 'bg-yellow-100'
    when :alert  then 'bg-yellow-100'
    when :error  then 'bg-yellow-100'
    else 'bg-yellow-100'
    end
  end
end
