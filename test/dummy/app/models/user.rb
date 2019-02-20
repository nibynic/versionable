class User < ApplicationRecord
  has_many :comments, foreign_key: :author_id
end
