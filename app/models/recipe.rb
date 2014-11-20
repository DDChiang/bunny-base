class Recipe < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  has_many :comments, :as => :commentable
  has_many :commenters, :through => :comments, :source => :commenter
end
