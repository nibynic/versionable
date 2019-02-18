module Versionable
  class Version < ActiveRecord::Base
    enum event: [:create, :update, :destroy], _suffix: true

    belongs_to :versionable, polymorphic: true
    belongs_to :author, polymorphic: true

    if Rails::VERSION::MAJOR < 5
      [:data_changes, :data_snapshot].each do |method|
        serialize method, JSON
      end
    end
  end
end