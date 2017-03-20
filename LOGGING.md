# Logging

Systemd catches all the output that goes `stdout` and `stderr` and keeps
it safe in a journal which takes care of the log size (and rotating) and
also supports extensive search/export options (see https://www.loggly.com/ultimate-guide/using-journalctl/).

But how to migrate from the old files way? Well, let's see:

## Puma

Go to `puma.rb` config file and remote any stdout redirection:

    stdout_redirect 'log/access.log', 'log/error.log'

## Nginx

I haven't manage to redirect nginx access log to STDOUT, although [some resources
claim it is possible](http://stackoverflow.com/questions/22541333/have-nginx-access-log-and-error-log-log-to-stdout-and-stderr-of-master-process). You can at least redirect STDERR to journal by using this:

    error_log stderr info;

    http {
      # didn't work for me
      # access_log /dev/stdout;
      ...
    }
