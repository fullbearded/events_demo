require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
# require "action_mailer/railtie"
require 'action_view/railtie'
# require "action_cable/engine"
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EventsDemo
  class Application < Rails::Application
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local

    config.active_record.raise_in_transactional_callbacks = true

    config.eager_load_paths += %W(#{config.root}/lib)

    config.i18n.load_path += Dir[config.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'zh-CN'
  end
end
