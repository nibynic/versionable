class Category < ApplicationRecord
  acts_as_versionable
  
  has_many :posts
end
