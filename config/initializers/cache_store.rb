config = Rails.application.config
if ["development", "test"].include?(Rails.env)
  config.cache_store = :memory_store, { size: 64.megabytes }
else
  config.cache_store = :redis_store, {
    url: Rails.application.secrets.redis_url,
    namespace: 'avalon'
  }
end
