module Versionable
  class Version < ActiveRecord::Base
    enum event: [:create, :update, :destroy], _suffix: true

    belongs_to :versionable, polymorphic: true
    belongs_to :author, polymorphic: true

  end
end
