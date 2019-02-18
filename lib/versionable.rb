require "versionable/railtie"
require "versionable/acts_as_versionable"
require "app/models/versionable/version"

module Versionable
  # Your code goes here...
end

ActiveRecord::Base.class_eval do
  include Versionable::ActsAsVersionable
end
