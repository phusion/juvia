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

  def escape_js_string(str)
    if str
      "'#{escape_javascript str}'"
    else
      nil
    end
  end

  def large_identity_tag(type, content)
    %Q{<h2 class="large_identity identity">#{image_tag "#{type}-48.png", :width => 48, :height => 48}#{h content}</h2>}.html_safe
  end

  def small_identity_tag(type, content, link = nil)
    result = %Q{<span class="small_identity identity">}
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

  def topic_comments_count_and_last_comment_date(topic)
    count = topic.comments.count
    if count == 1
      result = "1 comment"
    else
      result = "#{count} comments"
    end
    if count > 0
      most_recent_comment = topic.comments.first
      result << ", last one on #{most_recent_comment.created_at.to_s(:long)}"
    end
    result
  end

  def html_unsafe(buffer)
    if buffer.html_safe?
      "" << buffer
    else
      buffer
    end
  end
end
