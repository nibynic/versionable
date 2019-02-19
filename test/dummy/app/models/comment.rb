class Comment < ApplicationRecord
  acts_as_versionable parent: :post

  belongs_to :post
  belongs_to :author, class_name: "User"
end
