rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

Resque.redis = Rails.application.secrets.redis_url

Resque.logger = Logger.new(Rails.root.join('log', "#{Rails.env}_resque.log"))
Resque.logger.level = Logger::INFO

# Enable schedule tab in Resque web ui
require 'resque-scheduler'
require 'resque/scheduler/server'
