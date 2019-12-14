require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require './config/initializers/modules.rb'

Bundler.require(*Rails.groups)

module ExpertPalmTree
  class Application < Rails::Application
    config.load_defaults 6.0
    config.api_only = true
    config.application = config_for(:application)
    config.active_record.schema_format = :sql
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.test_framework :rspec, views: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.assets = false
      g.view_specs = false
      g.helper = false
    end
  end
end
