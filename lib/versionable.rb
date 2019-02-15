require "versionable/railtie"
require_relative "versionable/acts_as_versionable"

module Versionable
  # Your code goes here...
end

ActiveRecord::Base.class_eval do
  include Versionable::ActsAsVersionable
end
