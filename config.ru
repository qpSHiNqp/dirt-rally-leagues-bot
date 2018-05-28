# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require ::File.expand_path('../lib/leagues/discord', __FILE__)

Leagues::Discord.run
run Rails.application
