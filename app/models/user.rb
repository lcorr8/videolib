class User < ActiveRecord::Base
  has_secure_password

  has_many :sections
  has_many :videos, through: :sections

  def slug
    self.username.downcase.gsub(" ","-")
  end

  def self.find_by_slug(sluggie_name)
    self.all.find{|user| user.slug == sluggie_name }
  end
end