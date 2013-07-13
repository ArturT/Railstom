# https://github.com/mperham/sidekiq/wiki/devise
# https://github.com/plataformatec/devise/wiki/How-To:-Send-devise-emails-in-background-(Resque,-Sidekiq-and-Delayed::Job)

Devise::Async.backend = :sidekiq
