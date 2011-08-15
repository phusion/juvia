# -*- Mode: Ruby; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-

require 'zlib'

class ApiController < ApplicationController
  layout nil
  
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!
  before_filter :handle_cors
  before_filter :populate_variables
  
  def show_topic
    @topic_title  = params[:topic_title]
    @topic_url    = params[:topic_url]
    @include_base = get_boolean_param(:include_base, true)
    @include_css  = get_boolean_param(:include_css, true)
    # Must come before error checking because the error
    # templates depend on @include_base/@include_css.
    
    require_params(:site_key, :topic_key, :container, :topic_title,
      :topic_url) || return
    
    if @topic = Topic.lookup(@site_key, @topic_key)
      render
    else
      render :partial => 'site_not_found'
    end
  end
  
  def add_comment
    require_params(:site_key, :topic_key, :topic_title, :topic_url, :content) || return
    @content = decompress(params[:content])
    
    if @content.blank?
      render :partial => 'content_may_not_be_blank'
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
          :referer => request.env['HTTP_REFERER'],
          :content => @content)
        render
      else
        render :partial => 'site_not_found'
      end
    end
  end
  
  def preview_comment
    require_params(:content) || return
    @content = decompress(params[:content])
  end

private
  def handle_cors
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    headers["Access-Control-Max-Age"] = (60 * 60 * 24).to_s
    if request.method == "OPTIONS"
      render :text => '', :content_type => 'text/plain'
    end
  end
  
  def populate_variables
    @container = params[:container]
    @site_key  = params[:site_key]
    @topic_key = params[:topic_key]
  end
  
  def require_params(*args)
    args.each do |arg|
      if params[arg].blank?
        @param_name = arg
        render :partial => 'missing_parameter'
        return false
      end
    end
    true
  end
  
  def get_boolean_param(name, default = false)
    if params[name].present?
      value = params[name].downcase
      value == 'true' || value == 'yes' || value == '1' || value == 'on'
    else
      default
    end
  end
  
  def decompress(str)
    result = Zlib::Inflate.inflate(str.unpack('m').first)
    result.force_encoding('utf-8') if result.respond_to?(:force_encoding)
    result
  end
end
