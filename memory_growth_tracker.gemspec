require_relative "lib/memory_growth_tracker/version"

Gem::Specification.new do |spec|
  spec.name = "memory_growth_tracker"
  spec.version = MemoryGrowthTracker::VERSION
  spec.authors = ["Klemen Nagode"]
  spec.email = ["klemen@topkey.io"]
  spec.homepage = "https://github.com/knagode/rails_memory_growth_tracker"
  spec.summary = "Rails memory growth detection and tracking"
  spec.description = "A Rails engine for detecting and tracking memory growth patterns in production applications"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/knagode/rails_memory_growth_tracker"

  spec.files = Dir["{app,config,lib}/**/*", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.0"
  spec.add_dependency "redis"
  spec.add_dependency "get_process_mem"

  spec.add_development_dependency "rspec-rails"
end
