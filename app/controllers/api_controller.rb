# -*- Mode: Ruby; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-

require 'zlib'

class ApiController < ApplicationController
  layout nil
  
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!
  before_filter :handle_cors
  before_filter :populate_variables

  class MissingParameter < StandardError
  end
  class UnacceptableFormat < StandardError
  end

  rescue_from MissingParameter do |exception|
    render :partial => 'missing_parameter'
  end
  rescue_from UnacceptableFormat do |exception|
    # Do nothing, response already sent.
  end
  
  def show_topic
    @topic_title = params[:topic_title]
    @topic_url   = params[:topic_url]
    @include_base = get_boolean_param(:include_base, true)
    @include_css  = get_boolean_param(:include_css, true)
    # Must come before error checking because the error
    # templates depend on @include_base/@include_css.

    prepare!(
      [:site_key, :topic_key, :container, :topic_title, :topic_url],
      [:html, :js]
    )

    if @topic = Topic.lookup(@site_key, @topic_key)
      render
    else
      render :partial => 'site_not_found'
    end
  end
  
  def add_comment
    prepare!(
      [:site_key, :topic_key, :topic_title, :topic_url, :content],
      [:html, :js, :json]
    )
    begin
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
    rescue => e
      log_exception(e)
      render :partial => 'internal_error'
    end
  end
  
  def preview_comment
    prepare!([], [:html, :js, :json])
    @content = decompress(params[:content])
  end

  def list_topics
    prepare!([:site_key], [:json, :jsonp])
    @site = Site.find_by_key(@site_key)
    if @site
      render
    else
      render :partial => 'site_not_found'
    end
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
    @container    = params[:container]
    @site_key     = params[:site_key]
    @topic_key    = params[:topic_key]
    @jsonp        = params[:jsonp]
  end

  def prepare!(required_params, accepted_formats)
    raise ArgumentError if accepted_formats.empty?

    required_params.each do |param_name|
      if params[param_name].blank?
        @param_name = param_name
        raise MissingParameter
      end
    end

    respond_to do |format|
      accepted_formats.each do |symbol|
        format.send(symbol) do
          # If we're responding to a jsonp request then we
          # check for the 'jsonp' parameter.
          if symbol == :jsonp && params[:jsonp].blank?
            @param_name = :jsonp
            @jsonp = 'console.error'
            raise MissingParameter
          end
        end
      end
    end
    raise UnacceptableFormat if performed?
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

  def log_exception(e)
    logger.error("#{e.class} (#{e}):\n  " <<
      e.backtrace.join("\n  "))
  end
end
