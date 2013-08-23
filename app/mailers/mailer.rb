class Mailer < ActionMailer::Base
  default :from => (ENV['JUVIA_EMAIL_FROM'] || Juvia::Application.config.from)
  uri = URI.parse(ENV['JUVIA_BASE_URL'] || Juvia::Application.config.base_url)
  default_url_options[:protocol] = uri.scheme
  default_url_options[:host] = uri.host

  def comment_posted(comment)
    @site    = comment.site
    @comment = comment
    mail(:to => comment.site.user.email, :subject => "New comment posted")
  end
end
