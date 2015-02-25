#/bin/bash
git pull origin master
bundle install --path vendor/bundle
bundle exec rake assets:precompile
kill -USR2 `cat /usr/local/app/soi/tmp/pids/unicorn.pid`
kill -WINCH `cat /usr/local/app/soi/tmp/pids/unicorn.pid.oldbin`
kill -QUIT `cat /usr/local/app/soi/tmp/pids/unicorn.pid.oldbin`
unicorn_rails -E production -c config/unicorn.rb -D -p 8080
sudo service nginx restart
