# Memory (RAM) Growth Tracker (detects memory bloats & leaks)

A Rails engine for detecting and tracking memory growth patterns and mamory swap operations in production applications. Helps you identify requests that consume high amounts of RAM, especially useful for debugging memory growth and performance issues on platforms like Heroku.

## Features

- Real-time memory usage monitoring
- Track highest memory consuming requests
- Account-level tracking for multi-tenant apps
- Redis-based data storage
- Web dashboard for viewing statistics
- Configurable thresholds and limits

<img width="1139" height="680" alt="s_2" src="https://github.com/user-attachments/assets/5e170097-77cf-4ec5-a7b0-47aeaf92135f" />

<img width="1142" height="696" alt="s_1" src="https://github.com/user-attachments/assets/68eeb503-e259-4dc0-b3b1-3438375b42d4" />

## Heroku Memory Issues

If you're getting **R14 - Memory quota exceeded** errors, it means your application is using swap memory. Swap uses the disk to store memory instead of RAM. Disk speed is significantly slower than RAM, so page access time is greatly increased. This leads to a significant degradation in application performance. An application that is swapping will be much slower than one that is not. No one wants a slow application, so getting rid of R14 Memory quota exceeded errors on your application is very important.

<img width="909" height="272" alt="Screenshot 2025-08-30 at 18 46 41" src="https://github.com/user-attachments/assets/65bb2131-4dfd-4974-9647-805e44bc35f7" />

Memory Leak Hunter helps you identify which specific requests are consuming excessive memory, allowing you to pinpoint and fix the root cause of these performance issues.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "memory_leak_hunter", git: "https://github.com/knagode/rails_memory_leak_hunter"
```

And then execute:

    $ bundle install

## Configuration

```
MemoryLeakHunter.configure do |config|
  config.redis_url = ENV.fetch(ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
end
```

Configure Memory Leak Hunter using environment variables:

| Environment Variable                      | Description                                                                    | Default Value |
| ----------------------------------------- | ------------------------------------------------------------------------------ | ------------- |
| `MEMORY_LEAK_HUNTER_ENABLED`              | Enable/disable memory tracking                                                 | `false`       |
| `MEMORY_LEAK_HUNTER_SKIP_REQUESTS`        | Number of initial requests to skip (avoids class loading overhead)             | `10`          |
| `MEMORY_LEAK_HUNTER_MEMORY_THRESHOLD_MB`  | Minimum memory difference (MB) to track a request                              | `1`           |
| `MEMORY_LEAK_HUNTER_RAM_BEFORE_THRESHOLD` | Minimum RAM usage (MB) before tracking (prevents tracking low-memory requests) | `0`           |
| `MEMORY_LEAK_HUNTER_MAX_STORED_URLS`      | Maximum number of URLs to store in Redis                                       | `20`          |
| `MEMORY_LEAK_HUNTER_REDIS_KEY`            | Name of environment variable containing Redis URL (e.g., `REDISCLOUD_URL`)     | `REDIS_URL`   |

The gem will read the Redis connection URL from the environment variable specified in `MEMORY_LEAK_HUNTER_REDIS_KEY`, falling back to `REDIS_URL` if not specified.

## Usage

Mount the engine in your routes within an authenticated section:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # ... other routes ...

  # Mount within authenticated admin section
  authenticate :admin_user do
    mount MemoryLeakHunter::Engine, at: "/admin/memory_leak_hunter"
  end
end
```

Enable memory tracking by setting:

```bash
MEMORY_LEAK_HUNTER_ENABLED=true
```

### ActiveAdmin Integration

To add Memory Leak Hunter to your ActiveAdmin Operations menu, add this to your ActiveAdmin initializer:

```ruby
# config/initializers/active_admin.rb
ActiveAdmin.setup do |config|
  # ... other config ...

  config.namespace :admin do |admin|
    admin.build_menu do |menu|
      # ... other menu items ...
      menu.add label: "Memory Leak Hunter", url: "/admin/memory_leak_hunter", parent: "Operations"
    end
  end
end
```

## Console Usage

```ruby
# View statistics
MemoryLeakHunter::Tracker.print_stats

# Get top memory consuming URLs
MemoryLeakHunter::Tracker.top_memory_urls

# Clear all data
MemoryLeakHunter::Tracker.clear_all_data
```

## License

The gem is available as open source under the [MIT License](LICENSE).
