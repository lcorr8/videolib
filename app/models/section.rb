class Section < ActiveRecord::Base
 
  belongs_to :user
  has_many :videos
  
  def slug
    self.name.downcase.gsub(" ","-")
  end

  def self.find_by_slug(slug)
    self.all.find{|a| a.slug == slug }
  end

  
end