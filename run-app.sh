#!/bin/bash

# Function to open a new terminal window and run a command
open_terminal() {
    osascript -e "tell application \"Terminal\"
        do script \"cd $(pwd) && $1\"
    end tell"
}

# Start Tomcat in a new terminal
open_terminal "./start-tomcat.sh"

# Wait a few seconds for Tomcat to start
sleep 5

# Start frontend in another new terminal
open_terminal "cd frontend && npm start"

echo "Application startup initiated:"
echo "- Tomcat backend running in a new terminal"
echo "- React frontend running in a new terminal"
echo "Please check the terminal windows for any errors" 