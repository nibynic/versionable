class Post < ApplicationRecord
  acts_as_versionable include: [:comments, :gallery]

  has_many :comments, dependent: :destroy
  has_many :photos, dependent: :destroy

  belongs_to :gallery, (Rails::VERSION::MAJOR >= 5 ? {optional: true} : {}).merge(dependent: :destroy)
  belongs_to :category, (Rails::VERSION::MAJOR >= 5 ? {optional: true} : {}).merge(dependent: :destroy)
end
