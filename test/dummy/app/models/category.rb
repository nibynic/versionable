class Category < ApplicationRecord
  acts_as_versionable

  has_many :posts
  has_many :banners, dependent: :destroy
end
