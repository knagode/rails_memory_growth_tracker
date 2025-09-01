module MemoryGrowthTracker
  class Engine < ::Rails::Engine
    isolate_namespace MemoryGrowthTracker

    # Configure the engine to not autoload anything by default
    config.autoload_paths = []
    config.eager_load_paths = []

    # Add only the app directory manually
    config.autoload_paths << "#{root}/app"
    config.eager_load_paths << "#{root}/app"

    # Configure Zeitwerk to ignore problematic directories
    initializer "memory_growth_tracker.configure_zeitwerk", before: :set_autoload_paths do
      # Tell Zeitwerk to ignore the entire gem directory structure except app
      Rails.autoloaders.main.ignore("#{root}/config")
      Rails.autoloaders.main.ignore("#{root}/lib")

      # Also remove from Rails autoload paths if they were added
      Rails.application.config.autoload_paths.reject! { |path| path.to_s.include?("memory_growth_tracker") && !path.to_s.end_with?("/app") }
      Rails.application.config.eager_load_paths.reject! { |path| path.to_s.include?("memory_growth_tracker") && !path.to_s.end_with?("/app") }
    end

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "memory_growth_tracker.middleware" do |app|
      if MemoryGrowthTracker.configuration.enabled?
        require "get_process_mem"
        app.config.middleware.use MemoryGrowthTracker::Middleware
      end
    end
  end
end
