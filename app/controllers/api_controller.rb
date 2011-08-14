# -*- Mode: Ruby; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-

require 'zlib'

class ApiController < ApplicationController
  layout nil
  
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!
  before_filter :populate_variables_and_set_headers
  
  def show_topic
    @topic_title  = params[:topic_title]
    @topic_url    = params[:topic_url]
    @include_base = get_boolean_param(:include_base, true)
    @include_css  = get_boolean_param(:include_css, true)
    
    if @topic = Topic.lookup(@site_key, @topic_key)
      render
    else
      render :partial => 'site_not_found_in_show_topic'
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
        render :partial => 'site_not_found'
      end
    end
  end
  
  def preview_comment
    @content = decompress(params[:content])
  end

private
  def populate_variables_and_set_headers
    @container = params[:container]
    @site_key  = params[:site_key]
    @topic_key = params[:topic_key]
    headers["Access-Control-Allow-Origin"] = "*"
  end
  
  def get_boolean_param(name, default = false)
    if params.has_key?(name)
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
