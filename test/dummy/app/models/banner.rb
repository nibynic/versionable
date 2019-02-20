class Banner < ApplicationRecord
  acts_as_versionable
  
  belongs_to :category
end
