require 'capistrano/serviceman/systemd_service'
require 'capistrano/serviceman/tools'

namespace :monit do
  include Capistrano::Serviceman::Tools

  desc "Upload monit config files and refresh daemon"
  task :install => 'config:local_dirs' do
    on_each_role_and_service do |cap, service, role, role_name|
      remote = "#{shared_path}/#{service.monit_file_name}"
      cap.upload! service.monit_for(role), remote
      cap.execute :chmod, '0700', remote
      cap.execute "sudo ln -sf #{remote} /etc/monit/conf.d"
      cap.execute "sudo monit reload"
    end
  end

  desc 'Start monit'
  task :start do
    on roles(:app) do |role|
      execute :monit, "-c #{shared_path}/.monitrc"
    end
  end

  desc 'Reload monit'
  task :reload do
    on roles(:app) do |role|
      execute :monit, "-c #{shared_path}/.monitrc", :reload
    end
  end

  desc 'Show monit status'
  task :status do
    on roles(:app) do |role|
      execute :monit, "-c #{shared_path}/.monitrc", :status
    end
  end

  desc 'Monitor all'
  task :monitor do
    on roles(:app) do |role|
      execute :monit, "-c #{shared_path}/.monitrc", :monitor, 'all'
    end
  end

  desc 'Unmonitor all'
  task :unmonitor do
    on roles(:app) do
      execute :monit, "-c #{shared_path}/.monitrc", :unmonitor, 'all'
    end
  end

  desc 'Monitor quit'
  task :quit do
    on roles(:app) do |role|
      execute :monit, "-c #{shared_path}/.monitrc", :quit
    end
  end

  def upload_monit_template(role)
    erb = File.read("config/deploy/templates/monitrc.erb")
    remote_user = role.user
    result = ERB.new(erb).result(binding)

    target = "#{shared_path}/monitrc"
    upload! StringIO.new(result), target
    execute :chmod, '0700', target
  end
end
