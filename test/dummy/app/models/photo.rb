class Photo < ApplicationRecord
  acts_as_versionable
  
  belongs_to :post
end
