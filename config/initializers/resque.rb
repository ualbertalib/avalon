rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

Resque.redis = Rails.application.secrets.redis_url

# Enable schedule tab in Resque web ui
require 'resque-scheduler'
require 'resque/scheduler/server'
