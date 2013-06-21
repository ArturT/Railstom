sidekiq_redis = {
  url: Figaro.env.redis_url,
  namespace: Figaro.env.sidekiq_namespace
}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_redis
end

# When in Unicorn, this block needs to go in unicorn's after_fork callback:
Sidekiq.configure_client do |config|
  config.redis = sidekiq_redis
end
