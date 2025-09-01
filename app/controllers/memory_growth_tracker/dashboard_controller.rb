module MemoryGrowthTracker
  class DashboardController < ApplicationController
    layout "memory_growth_tracker/application"
    def index
      @memory_hunter_enabled = MemoryGrowthTracker.configuration.enabled?

      if @memory_hunter_enabled
        @stats = MemoryGrowthTracker::Tracker.stats
        @top_urls = MemoryGrowthTracker::Tracker.top_memory_urls(limit: 20)
        @max_memory_url = MemoryGrowthTracker::Tracker.max_memory_url
      else
        @stats = nil
        @top_urls = []
        @max_memory_url = nil
      end
    end

    def clear
      before_stats = MemoryGrowthTracker::Tracker.stats
      MemoryGrowthTracker::Tracker.clear_all_data

      redirect_to root_path, notice: "✅ All memory usage statistics have been reset successfully! Cleared #{before_stats[:stored_urls_count]} URLs and reset max memory diff from #{before_stats[:max_memory_diff]} MB to 0.0 MB."
    rescue StandardError => e
      redirect_to root_path, alert: "❌ Error clearing memory statistics: #{e.message}"
    end

    private

    def authenticate_user!
      # Override this method in your host app if you need authentication
      # For example: authenticate_admin_user! or redirect_to login_path unless current_user&.admin?
    end
  end
end
