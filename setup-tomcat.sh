#!/bin/bash

# Function to compare version numbers
version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}

# Check Java version
if command -v java >/dev/null 2>&1; then
    JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F. '{print $1}')
    echo "Found Java version: $JAVA_VERSION"
    
    if [ "$JAVA_VERSION" -lt 21 ]; then
        echo "Error: Java version $JAVA_VERSION is too old"
        echo "This application requires Java 21 or newer"
        exit 1
    fi
else
    echo "Error: Java not found"
    echo "Please install Java 21 or newer"
    exit 1
fi

# Find Homebrew Tomcat installation and version
if command -v brew >/dev/null 2>&1; then
    TOMCAT_VERSION=$(brew list --versions tomcat | awk '{print $2}')
    BREW_TOMCAT_PATH=$(brew --prefix tomcat)/libexec
    
    if [ ! -d "$BREW_TOMCAT_PATH" ]; then
        echo "Error: Tomcat installation not found at $BREW_TOMCAT_PATH"
        echo "Please make sure Tomcat is installed via Homebrew"
        exit 1
    fi

    echo "Found Tomcat version: $TOMCAT_VERSION"
    
    # Check minimum version requirement (assuming we need at least Tomcat 9)
    if version_gt "9.0.0" "$TOMCAT_VERSION"; then
        echo "Error: Tomcat version $TOMCAT_VERSION is too old"
        echo "This application requires Tomcat 9.0.0 or newer"
        exit 1
    fi
else
    echo "Error: Homebrew not found"
    echo "Please install Homebrew and Tomcat"
    exit 1
fi

# Set CATALINA_HOME if not already set
if [ -z "$CATALINA_HOME" ]; then
    export CATALINA_HOME="$BREW_TOMCAT_PATH"
    echo "Setting CATALINA_HOME to $CATALINA_HOME"
fi

# Get the project root directory
PROJECT_ROOT=$(pwd)

echo "Setting up Tomcat environment for basic-web project..."
echo "Using Tomcat installation at: $CATALINA_HOME"

# Backup existing configuration if it exists
BACKUP_DIR="tomcat/conf/backup_$(date +%Y%m%d_%H%M%S)"
if [ -d "tomcat/conf" ]; then
    echo "Backing up existing configuration to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    cp -r tomcat/conf/* "$BACKUP_DIR/" 2>/dev/null || true
fi

# Create symlinks for essential Tomcat files and directories
echo "Creating symlinks to Tomcat installation..."

# Symlink bin directory
ln -sfn "$CATALINA_HOME/bin" tomcat/bin

# Symlink lib directory
ln -sfn "$CATALINA_HOME/lib" tomcat/lib

# Symlink essential configuration files (but not server.xml which we maintain separately)
mkdir -p tomcat/conf
ln -sfn "$CATALINA_HOME/conf/web.xml" tomcat/conf/web.xml
ln -sfn "$CATALINA_HOME/conf/catalina.properties" tomcat/conf/catalina.properties
ln -sfn "$CATALINA_HOME/conf/catalina.policy" tomcat/conf/catalina.policy
ln -sfn "$CATALINA_HOME/conf/logging.properties" tomcat/conf/logging.properties

# Create directories if they don't exist
mkdir -p tomcat/logs
mkdir -p tomcat/temp
mkdir -p tomcat/work
mkdir -p tomcat/webapps

# Create version info file
cat > tomcat/VERSION.txt << EOF
Tomcat Version: $TOMCAT_VERSION
Setup Date: $(date)
CATALINA_HOME: $CATALINA_HOME
EOF

# Create a convenience script to start Tomcat with this configuration
cat > start-tomcat.sh << EOF
#!/bin/bash

# Check if Tomcat is already running
if [ -f "tomcat/catalina.pid" ]; then
    if ps -p \$(cat tomcat/catalina.pid) > /dev/null; then
        echo "Tomcat is already running with PID \$(cat tomcat/catalina.pid)"
        echo "Stop it first using: ./stop-tomcat.sh"
        exit 1
    else
        rm tomcat/catalina.pid
    fi
fi

export CATALINA_BASE="$PROJECT_ROOT/tomcat"
export CATALINA_HOME="$CATALINA_HOME"
export CATALINA_PID="$PROJECT_ROOT/tomcat/catalina.pid"

echo "Starting Tomcat..."
echo "CATALINA_BASE: \$CATALINA_BASE"
echo "CATALINA_HOME: \$CATALINA_HOME"
\$CATALINA_HOME/bin/catalina.sh run
EOF

# Create a stop script
cat > stop-tomcat.sh << EOF
#!/bin/bash
if [ -f "tomcat/catalina.pid" ]; then
    export CATALINA_BASE="$PROJECT_ROOT/tomcat"
    export CATALINA_HOME="$CATALINA_HOME"
    echo "Stopping Tomcat..."
    \$CATALINA_HOME/bin/catalina.sh stop
    rm -f tomcat/catalina.pid
else
    echo "No Tomcat PID file found"
fi
EOF

chmod +x start-tomcat.sh stop-tomcat.sh

echo "Tomcat setup completed successfully!"
echo "Your local Tomcat environment is now configured."
echo ""
echo "Available commands:"
echo "1. Start Tomcat:  ./start-tomcat.sh"
echo "2. Stop Tomcat:   ./stop-tomcat.sh"
echo ""
echo "Your application will be available at: http://localhost:8080/basic-web"
echo ""
echo "Note: Make sure no other Tomcat instance is running on port 8080"
echo "Tomcat version information has been saved to tomcat/VERSION.txt" 