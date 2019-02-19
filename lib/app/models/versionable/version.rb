module Versionable
  class Version < ActiveRecord::Base
    enum event: [:create, :update, :destroy], _suffix: true

    belongs_to :versionable, polymorphic: true
    belongs_to :author, polymorphic: true

    if Versionable::SERIALIZE_JSON
      [:data_changes, :data_snapshot].each do |method|
        serialize method, JSON
      end
    end

    def self.table_name
      "versionable_versions"
    end
  end
end
