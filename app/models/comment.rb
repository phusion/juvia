require 'digest/md5'

class Comment < ActiveRecord::Base
  belongs_to :topic
  
  before_validation :nullify_blank_fields
  
  def author_email_md5
    if author_email
      Digest::MD5.hexdigest(author_email.downcase)
    else
      nil
    end
  end

private
  def nullify_blank_fields
    self.author_name  = nil if author_name.blank?
    self.author_email = nil if author_email.blank?
  end
end
