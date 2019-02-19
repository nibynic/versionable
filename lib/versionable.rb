require "versionable/config"
require "versionable/railtie"
require "versionable/enum_patch"
require "versionable/acts_as_versionable"
require "app/models/versionable/version"

ActiveRecord::Base.class_eval do
  include Versionable::ActsAsVersionable
end
