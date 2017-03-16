require 'capistrano/serviceman/systemd_service'
require 'capistrano/serviceman/tools'

namespace :load do
  task :defaults do
    include Capistrano::Serviceman::Tools
    set :serviceman_config_dir, -> { config_dir }
  end
end


namespace :serviceman do
  include Capistrano::Serviceman::Tools

  each_service_name do |type|
    namespace type do
      desc "Print Systemd and Monit status of #{type.capitalize} service"
      task :status do
	on_each_role_and_service(service_filter: type) do |cap, service, role, rolename|
          cap.execute "sudo systemctl status #{service.name}"
          cap.execute "sudo monit status #{service.monit_process}"  
        end
      end
    end
  end

  namespace :install do
    desc "Upload systemd .service file and refresh daemon"
    task :systemd => 'config:local_dirs' do
      on_each_role_and_service do |cap, service, role, role_name|
        remote = "#{shared_path}/#{service.name}"
        cap.upload! service.config_for(role), remote
        cap.execute "sudo mv -f #{remote} /lib/systemd/system/#{service.name}"
        cap.execute "sudo systemctl daemon-reload"
        # enable and start (--now) the service
        cap.execute "sudo systemctl enable --now #{service.name}"
      end
    end

    desc "Upload monit config files and refresh daemon"
    task :monit => 'config:local_dirs' do
      on_each_role_and_service do |cap, service, role, role_name|
        remote = "#{shared_path}/#{service.monit_file_name}"
        cap.upload! service.monit_for(role), remote
        cap.execute :chmod, '0700', remote
        cap.execute "sudo ln -sf #{remote} /etc/monit/conf.d"
        cap.execute "sudo monit reload"
      end
    end
  end
end
