# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Networks::Application

  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    username == CFG["delayed_web"]["user"]
    password == CFG["delayed_web"]["pass"]
  end
