#!/bin/bash

# Check if Tomcat is already running
if [ -f "tomcat/catalina.pid" ]; then
    if ps -p $(cat tomcat/catalina.pid) > /dev/null; then
        echo "Tomcat is already running with PID $(cat tomcat/catalina.pid)"
        echo "Stop it first using: ./stop-tomcat.sh"
        exit 1
    else
        rm tomcat/catalina.pid
    fi
fi

export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"

export CATALINA_BASE="/Users/sammy.samejima/privatespace/front-back-web/tomcat"
export CATALINA_HOME="/opt/homebrew/opt/tomcat/libexec"
export CATALINA_PID="/Users/sammy.samejima/privatespace/front-back-web/tomcat/catalina.pid"

echo "Starting Tomcat..."
echo "CATALINA_BASE: $CATALINA_BASE"
echo "CATALINA_HOME: $CATALINA_HOME"
$CATALINA_HOME/bin/catalina.sh run
