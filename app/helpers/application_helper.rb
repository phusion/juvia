module ApplicationHelper
  def render_markdown(str)
    BlueCloth.new(str, :escape_html => true, :strict_mode => false).to_html.html_safe
  end
end
