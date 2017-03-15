require "capistrano/serviceman/version"

load File.expand_path('../tasks/systemd.rake',  __FILE__)
load File.expand_path('../tasks/monit.rake',  __FILE__)

# require "capistrano/serviceman/tools"
# require "capistrano/serviceman/systemd_service"

module Capistrano
  module Serviceman
    # Your code goes here...
  end
end
