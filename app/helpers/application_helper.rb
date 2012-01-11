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

  def large_identity_tag(type, content)
    %Q{<h2 class="identity large">#{image_tag "#{type}-48.png", :width => 48, :height => 48}#{h content}</h2>}.html_safe
  end

  def small_identity_tag(type, content, link = nil)
    result = %Q{<span class="identity small">}
    if link
      result << %Q{<a href="#{h url_for(link)}">}
    end
    result << image_tag("#{type}-22.png", :width => 22, :height => 22)
    result << h(content)
    if link
      result << %Q{</a>}
    end
    result.html_safe
  end
end
