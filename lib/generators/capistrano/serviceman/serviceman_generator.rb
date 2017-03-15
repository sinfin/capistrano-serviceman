require 'fileutils'


class Capistrano::ServicemanGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  class_option :types, type: :array, required: false,
               default: %w( puma sidekiq)

  class_option :stages, type: :array, required: false,
               default: %w( production staging )

  def puma
    return if disabled?(:puma)

    stages.each do |stage|
      copy_file 'puma.service.erb',
                "#{config_dir}/#{stage}/app/puma.service.erb"
      copy_file 'puma_monitrc.erb',
                "#{config_dir}/#{stage}/app/puma_monitrc.erb"
    end
  end

  def sidekiq
    return if disabled?(:sidekiq)

    stages.each do |stage|
      copy_file 'sidekiq.service.erb',
                "#{config_dir}/#{stage}/worker/sidekiq.service.erb"
      copy_file 'sidekiq_monitrc.erb',
                "#{config_dir}/#{stage}/worker/sidekiq_monitrc.erb"
    end
  end

  private

  def stages
    options[:stages]
  end

  def disabled?(name)
    !options[:types].include?(name.to_s)
  end

  def config_dir
    "config/deploy/templates"
  end

  def application
    Rails.application.class.parent_name.underscore
  end

  def user
    application
  end

  def env(key)
    "<%= ENV['#{key}'] %>"
  end

  def ruby_version
    `cat .ruby-version`.strip.presence ||
      '2.4.0'
  end

end
