#!/bin/bash
if [ -f "tomcat/catalina.pid" ]; then
    export CATALINA_BASE="/Users/sammy.samejima/privatespace/front-back-web/tomcat"
    export CATALINA_HOME="/opt/homebrew/opt/tomcat/libexec"
    echo "Stopping Tomcat..."
    $CATALINA_HOME/bin/catalina.sh stop
    rm -f tomcat/catalina.pid
else
    echo "No Tomcat PID file found"
fi
