require "memory_growth_tracker/version"
require "memory_growth_tracker/engine"

module MemoryGrowthTracker
  autoload :Configuration, "memory_growth_tracker/configuration"
  autoload :Middleware, "memory_growth_tracker/middleware"
  autoload :Tracker, "memory_growth_tracker/tracker"

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
