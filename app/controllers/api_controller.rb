require 'zlib'

class ApiController < ApplicationController
  layout nil
  
  def load_topic
    @container   = params[:container]
    @site_key    = params[:site_key]
    @topic_key   = params[:topic_key]
    @topic_title = params[:topic_title]
    @topic_url   = params[:topic_url]
    @include_css = get_boolean_param(:include_css, true)
    
    if @topic = Topic.lookup(@site_key, @topic_key)
      render_jsonp :template => 'api/load_topic.js',
        :include_base_js => true,
        :eval => true
    else
      render_jsonp 'topic_not_found'
    end
  end
  
  def add_comment
    Topic.transaction do
      @topic = Topic.lookup_or_create(
        params[:site_key],
        params[:topic_key],
        params[:topic_title],
        params[:topic_url])
      if @topic
        @comment = @topic.comments.create!(
          :author_name => params[:author_name],
          :author_email => params[:author_email],
          :content => unpack(params[:content]))
        render_jsonp :partial => 'api/comment', :locals => { :comment => @comment }
      else
        render_jsonp 'site_not_found'
      end
    end
  end

private
  def get_boolean_param(name, default = false)
    if params.has_key?(name)
      value = params[name].downcase
      value == 'true' || value == 'yes' || value == '1' || value == 'on'
    else
      default
    end
  end
  
  def render_jsonp(*args)
    options            = args.extract_options!
    include_base_js    = options.delete(:include_base_js)
    eval               = options.delete(:eval)
    
    headers["Content-Type"] = "text/javascript; charset=utf-8"
    content = render_to_string(*args)
    
    if eval
      content = %Q{Juvia.eval(#{content.to_json})}.html_safe
    else
      content = %Q{Juvia.callback(#{content.to_json})}.html_safe
    end
    
    if include_base_js
      temp = render_to_string(:partial => 'api/base.js')
      temp << "\n" << content << "\n"
      content = temp
    end
    
    render :text => content
  end
  
  def unpack(str)
    result = Zlib::Inflate.inflate(str.unpack('m').first)
    result.force_encoding('utf-8') if result.respond_to?(:force_encoding)
    result
  end
end
