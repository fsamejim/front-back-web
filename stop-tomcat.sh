#!/bin/bash

# Set environment variables
export CATALINA_BASE="$(pwd)/tomcat"
export CATALINA_HOME="/opt/homebrew/Cellar/tomcat/11.0.7/libexec"

# First try graceful shutdown
if [ -f "tomcat/catalina.pid" ]; then
    echo "Attempting graceful shutdown..."
    $CATALINA_HOME/bin/catalina.sh stop 10 -force
    sleep 5
fi

# If process still exists, force kill
if [ -f "tomcat/catalina.pid" ]; then
    PID=$(cat tomcat/catalina.pid)
    if ps -p $PID > /dev/null; then
        echo "Force killing Tomcat process $PID..."
        kill -9 $PID
    fi
    rm -f tomcat/catalina.pid
fi

# Clean up any remaining processes
pkill -f "java.*tomcat" || true

echo "Tomcat stopped."
