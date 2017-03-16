# Capistrano Serviceman

Capistrano Serviceman helps you to manage Puma and Sidekiq
processes using Systemd and watch them by Monit. Configuration
is driven by templates directory structure, making it very
easy to adjust all to your liking.

## Installation

Add this line to your Gemfile:

```ruby
gem 'capistrano-serviceman'
```

and this to Capfile: 

```ruby
require 'capistrano/serviceman'
```

## Usage

Create Systemd `.service` and `monitrc` templates using generator:

    rails generate capistrano:serviceman
    
This will create Puma and Sidekiq template files for Monit and Systemd
in both `staging` and `production` environment. You will find them in
`config/deploy/templates/<stage>`. You can limit the stages and roles
by `--types` and `--stages` switches.

**You have to rename directories to match your server role names.**

Use capistrano tasks to upload the configuration and enable 
defined services and their monitoring:

    cap production serviceman:install:systemd
    cap production serviceman:install:monit
    
Manage them safely from home:    

    # prints Systemd and Monit status of Puma service
    cap production serviceman:puma:status

    # start service and monitoring
    cap production serviceman:puma:start    

    # unmonit and stop the service
    cap production serviceman:puma:stop    

## Directories & Filenames ~ Roles & Services

The directory structure and template filenames define on which role
is deployed which service. By default Pumas are installed on `app` 
machines while Sidekiqs are deployed on `worker` machines. You will 
see a tree like this for production (same for `staging`):

    production/
    ├── app
    │   ├── puma_monitrc.erb
    │   └── puma.service.erb
    └── worker
        ├── sidekiq_monitrc.erb
        └── sidekiq.service.erb

You can change what is deployed on what role by simply renaming
files or directories. See the examples below.

## Examples

Do you want everything on one machine? No problem. Here is a setup
for 3 Sidekiqs and one Puma. Sidekiqs are ignored by Monit:

    production
        └── app
            ├── puma_monitrc.erb
            ├── puma.service.erb
            ├── sidekiq_1.service.erb
            ├── sidekiq_2.service.erb
            └── sidekiq_3.service.erb

## Disclaimer

I am not a sysadmin, Linux expert or anything like this. I am
doing devops just because I have to (I enjoy it don't get me 
wrong!) But please bare in mind that all the default configs
are **by no means best practices**. They are just _practices_.
They keep our [cogwheels](https://www.squared.one) spinning
though ;D


## Contributing

Serviceman is WIP and it is suited to our purposes. There
are no settings, switched, everyting is run via `sudo` etc.
Please submit pull requests polishing those rough edges
if you find the gem useful!

Bug reports and pull requests are welcome on GitHub at https://github.com/HakubJozak/capistrano-serviceman.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

