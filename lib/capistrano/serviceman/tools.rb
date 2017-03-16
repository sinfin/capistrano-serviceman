module Capistrano::Serviceman::Tools
  private

  def config_dir(stage = nil)
    stage_dir = stage || fetch(:stage)
    "config/deploy/templates/#{stage_dir}"
  end

  def on_each_role_and_service(service_filter: nil)
    on_each_systemd_role in: :sequence do |role, role_name, cap|
      each_service_for(role_name) do |service|
        if service_filter &&
           service.type != service_filter
          next
        else
          yield cap, service, role, role_name
        end
      end
    end
  end

  def on_each_systemd_role(options = {})
    Dir.entries(config_dir).each do |dir|
      if Dir.exist?("#{config_dir}/#{dir}")
        on roles(dir), options do |role|
          yield role, dir, self
        end
      end
    end
  end

  def each_service_name(&block)
    raise 'Block missing' unless block_given?
    
    names = %w( production staging ).map do |stage|
      Dir["#{config_dir(stage)}/*/*.service.erb"].map do |f|    
        File.basename(f, '.service.erb')
      end      
    end.flatten.uniq

    names.each(&block)
  end

  def each_service_for(role_name)
    Dir["#{config_dir}/#{role_name}/*.service.erb"].each do |f|
      type = File.basename(f, '.service.erb')
      app = fetch(:application)
      
      yield Capistrano::Serviceman::SystemdService.new(
              type: type,
              role_name: role_name,
              app: app,
              capistrano: self)
    end
  end

end
