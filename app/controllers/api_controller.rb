require 'zlib'

class ApiController < ApplicationController
  layout nil
  
  before_filter :populate_variables
  
  def show_topic
    @container    = params[:container]
    @topic_title  = params[:topic_title]
    @topic_url    = params[:topic_url]
    @include_base = get_boolean_param(:include_base, true)
    @include_css  = get_boolean_param(:include_css, true)
    
    if @topic = Topic.lookup(@site_key, @topic_key)
      render
    else
      render_error 'topic_not_found.html'
    end
  end
  
  def add_comment
    @content = decompress(params[:content])
    
    if @content.blank?
      render 'content_may_not_be_blank'
      return
    end
    
    Topic.transaction do
      @topic = Topic.lookup_or_create(
        @site_key,
        @topic_key,
        params[:topic_title],
        params[:topic_url])
      if @topic
        @comment = @topic.comments.create!(
          :author_name => params[:author_name],
          :author_email => params[:author_email],
          :author_ip => request.env['REMOTE_ADDR'],
          :author_user_agent => request.env['HTTP_USER_AGENT'],
          :referrer => request.env['HTTP_REFERER'],
          :content => @content)
        render
      else
        render_error 'site_not_found'
      end
    end
  end
  
  def preview_comment
    @content = decompress(params[:content])
  end

private
  def populate_variables
    @site_key     = params[:site_key]
    @topic_key    = params[:topic_key]
  end
  
  def get_boolean_param(name, default = false)
    if params.has_key?(name)
      value = params[name].downcase
      value == 'true' || value == 'yes' || value == '1' || value == 'on'
    else
      default
    end
  end
  
  def render_error(*args)
    response_to do |format|
      format.html do
        render(*args)
      end
      format.js do
        options = {
          :action => 'ShowError',
          :html => render_to_string(*args)
        }
        render :text => %Q{Juvia.handleResponse(#{options.to_json})}
      end
    end
  end
  
  def decompress(str)
    result = Zlib::Inflate.inflate(str.unpack('m').first)
    result.force_encoding('utf-8') if result.respond_to?(:force_encoding)
    result
  end
end
