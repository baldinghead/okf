#!/bin/sh

set -e

TIMEOUT=${TIMEOUT-60}
APP_ROOT=/usr/local/app/soi
#APP_ROOT=`cd \`dirname $0\`/..; pwd`
PID=$APP_ROOT/tmp/pids/unicorn.pid
RAILS_ENV=production
#CMD="su -l ec2-user -c 'bundle exec unicorn -D -c $APP_ROOT/config/unicorn.rb -E $RAILS_ENV'"
INIT_CONF=$APP_ROOT/config/init.conf
action="$1"
set -u

old_pid="$PID.oldbin"

cd $APP_ROOT || exit 1

sig () {
    test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
    test -s $old_pid && kill -$1 `cat $old_pid`
}

case $action in
start)
    sig 0 && echo >&2 "Already running" && exit 0
    ~/.rbenv/shims/bundle exec unicorn_rails -D -c $APP_ROOT/config/unicorn.rb -E $RAILS_ENV -p 8080
    ;;
stop)
    sig QUIT && exit 0
    echo >&2 "Not running"
    ;;
force-stop)
    sig TERM && exit 0
    echo >&2 "Not running"
    ;;
restart|reload)
    sig HUP && echo reloaded OK && exit 0
    echo >&2 "Couldn't reload, starting '$CMD' instead"
    $CMD
    ;;
upgrade)
    if sig USR2 && sleep 2 && sig 0 && oldsig QUIT
    then
        n=$TIMEOUT
        while test -s $old_pid && test $n -ge 0
        do
            printf '.' && sleep 1 && n=$(( $n - 1 ))
        done
        echo

        if test $n -lt 0 && test -s $old_pid
        then
            echo >&2 "$old_pid still exists after $TIMEOUT seconds"
            exit 1
        fi
        exit 0
    fi
    echo >&2 "Couldn't upgrade, starting '$CMD' instead"
    $CMD
    ;;
reopen-logs)
    sig USR1
    ;;
*)
    echo >&2 "Usage: $0 <start|stop|restart|upgrade|force-stop|reopen-logs>"
    exit 1
    ;;
esac
