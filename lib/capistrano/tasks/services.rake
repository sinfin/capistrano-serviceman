require 'capistrano/serviceman/systemd_service'
require 'capistrano/serviceman/tools'

namespace :load do
  task :defaults do
    set :service_config_dir, -> { "config/deploy/templates/#{fetch(:stage)}" }
  end
end

namespace :systemd do
  include Capistrano::Serviceman::ServiceTools

  desc "Upload systemd .service file and refresh daemon"
  task :install => 'config:local_dirs' do
    on_each_role_and_service do |cap, service, role, role_name|
      remote = "#{shared_path}/#{service.name}"
      cap.upload! service.config_for(role), remote
      cap.execute "sudo mv -f #{remote} /lib/systemd/system/#{service.name}"
      cap.execute "sudo systemctl daemon-reload"
      # enable and start (--now) the service
      cap.execute "sudo systemctl enable --now #{service.name}"
    end
  end

  %I( status start stop enable disable ).each do |verb|
    desc "#{verb} systemd service"
    task verb do
      on_each_role_and_service do |cap, service, role, role_name|
        cap.execute "sudo systemctl -n 20 #{verb} #{service.name}"
      end
    end
  end

end
