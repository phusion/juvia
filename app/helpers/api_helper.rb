module ApiHelper
  def juvia_handle_response(options)
    "Juvia.handleResponse(#{options.to_json})".html_safe
  end
end
