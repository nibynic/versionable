require_relative 'boot'

require 'rails/all'

if Rails::VERSION::MAJOR < 5
  module Versionable
    SERIALIZE_JSON = true
  end
end

Bundler.require(*Rails.groups)
require "versionable"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    if Rails::VERSION::MAJOR >= 5
      config.load_defaults 5.2
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
