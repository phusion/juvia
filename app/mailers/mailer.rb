class Mailer < ActionMailer::Base
  default :from => Juvia::Application.config.from
  uri = URI.parse(Juvia::Application.config.base_url)
  default_url_options[:protocol] = uri.scheme
  default_url_options[:host] = uri.host

  def comment_posted_for_moderators(comment)
    @site    = comment.site
    @comment = comment
    mail(:to => comment.site.user.email, :subject => "New comment posted")
  end

  def comment_posted_for_users(comment)
    @site    = comment.site
    @comment = comment
    mail(:to => comment.site.user_notification_email, :subject => "New comment posted")
  end
end
