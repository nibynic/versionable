$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "versionable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "versionable"
  spec.version     = Versionable::VERSION
  spec.authors     = ["Paweł Bator"]
  spec.email       = ["jembezmamy@users.noreply.github.com"]
  spec.homepage    = "http://github.com/nibynic/versionable"
  spec.summary     = "Versioning for Active Record"
  spec.description = "Simple hash-based versioning for Rails Active Record"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails"

  spec.add_development_dependency "sqlite3", "~> 1.3.6"
  spec.add_development_dependency "appraisal"
end
