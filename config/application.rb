require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Leagues
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Async Jobs
    config.active_job.queue_adapter = :delayed_job
    #config.active_job.queue_adapter = :async

    # Timezone
    config.time_zone = 'Asia/Tokyo'
    config.active_record.default_timezone = :local

    config.discord = config_for(:discord)
  end
end
