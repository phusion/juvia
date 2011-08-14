module ApplicationHelper
  extend self
  
  def maybe_active(*navigation_ids)
    if @navigation_id && navigation_ids.include?(@navigation_id)
      'active'
    elsif @navigation_ids
      @navigation_ids.each do |id|
        if navigation_ids.include?(id)
          return 'active'
        end
      end
      nil
    else
      nil
    end
  end
  
  def render_markdown(str)
    BlueCloth.new(str, :escape_html => true, :strict_mode => false).to_html.html_safe
  end
end
