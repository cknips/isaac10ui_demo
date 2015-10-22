workers Integer(ENV["WEB_CONCURRENCY"] || 1)
threads_count = Integer(ENV["MAX_THREADS"] || 1)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
environment ENV["RACK_ENV"] || "development"
bind        'tcp://192.168.50.4:3001'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
