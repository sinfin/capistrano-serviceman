require 'active_support/core_ext/module/delegation'

class Capistrano::Rails::Services::Systemd

  attr_reader :name, :capistrano
  delegate :current_path, :shared_path, :fetch, to: :capistrano

  def initialize(type:, role_name:, app:, capistrano:)
    @capistrano = capistrano
    @type, @app = type, app
    @role_name = role_name
    @name = [ app, '_', type, '.service' ].join
  end

  def description
    "#{@app.capitalize} #{@type.capitalize}"
  end

  def config_for(role)
    erb = File.read(template_file)
    StringIO.new(ERB.new(erb).result(binding))
  end

  def monit_for(role)
    erb = File.read(monit_template_file)
    StringIO.new(ERB.new(erb).result(binding))
  end

  def monit_file_name
    [ @app, @type, 'monitrc' ].join('_')
  end

  def monit_process
    @name
  end

  def systemd_service
    @name
  end

  # def generate_systemd_config(role)
    # template_name = "#{@type}.service.erb"
    # templates = [
    #   # overrided locations
    #   "config/deploy/templates/#{template_name}-#{role.hostname}-#{fetch(:stage)}",
    #   "config/deploy/templates/#{template_name}-#{role.hostname}",
    #   "config/deploy/templates/#{template_name}",
    #   # this gem default template
    #   File.expand_path("../../templates/#{template_name}", __FILE__)
    # ]
    #
    # template = templates.find { |f| File.exists?(f) }
    #
    # raise "Couldn't find any service file in #{templates}" unless template
    # StringIO.new(ERB.new(File.read(template)).result(binding))
  #  end

  def monit_template_file
    "#{config_dir}/#{@role_name}/#{@type}_monitrc.erb"
  end

  def template_file
    "#{config_dir}/#{@role_name}/#{@type}.service.erb"
  end

  private

  def config_dir
    fetch(:service_config_dir)
  end

  def rvm_do(cmd, role)
    user = role.user
    path = fetch(:rvm_path).sub('~', "/home/#{user}")
    "#{path}/bin/rvm #{fetch(:rvm_ruby_version)} do #{cmd}"
  end

  # def rvm_do_as_remote_user(cmd, role)
  #   rvm = rvm_do(cmd, role)
  #   with_user = "cd #{current_path} && ( export RACK_ENV=#{fetch(:stage)} ; #{rvm})"
  #   "/usr/bin/sudo -u #{role.user} /bin/bash -c '#{with_user}'"
  # end

end
