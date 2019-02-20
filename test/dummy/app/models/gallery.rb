class Gallery < ApplicationRecord
  acts_as_versionable parent: -> { post }

  has_one :post
end
