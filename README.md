# Full Stack Web Application

How to run the application:
  The culprit was Cursor's Java extension auto-managing Spring Boot applications:
  1. Detected your manual Tomcat process
  2. Shut it down to prevent "conflicts"
  3. Failed to restart it properly under IDE management

  Solutions for future development:

  1. Keep using terminal:
       Run ./start-tomcat.sh and npm start outside Cursor
  2. Disable Java auto-management: In Cursor settings, disable Spring Boot auto-start features
  3. Use Cursor's run configs: Let Cursor handle the entire lifecycle instead of manual scripts

  Your external Tomcat configuration is working perfectly - the issue was just IDE interference, not your setup!


CatGPT suggest:
   Run your Tomcat backend manually:
   ./start-tomcat.sh

   Run your React frontend manually:
   npm start
   
•	Use separate terminal tabs or windows (outside of Claude or Cursor if needed)

Solutrion: use run-app script
 ./run-app.sh


This project is a full-stack web application that consists of a React frontend and a Spring Boot backend, using JWT for secure authentication.

## Project Structure

```
front-back-web/
├── frontend/                    # React frontend application
│   ├── src/                    # React source code
│   │   ├── components/        # React components
│   │   │   ├── auth/         # Authentication related components
│   │   │   └── common/       # Shared components
│   │   ├── contexts/         # React contexts (e.g., AuthContext)
│   │   ├── services/         # API service calls
│   │   └── App.tsx          # Main application component
│   ├── public/               # Static files
│   └── package.json         # Frontend dependencies
│
├── backend/                   # Spring Boot backend application
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/example/basicweb/
│   │   │   │   ├── config/          # Configuration classes
│   │   │   │   │   └── SecurityConfig.java
│   │   │   │   ├── controller/      # REST controllers
│   │   │   │   │   └── AuthController.java
│   │   │   │   ├── model/           # Data models
│   │   │   │   │   └── User.java
│   │   │   │   ├── repository/      # Data access layer
│   │   │   │   │   └── UserRepository.java
│   │   │   │   ├── security/        # Security related classes
│   │   │   │   │   └── JwtAuthenticationFilter.java
│   │   │   │   └── service/         # Business logic
│   │   │   │       └── UserService.java
│   │   │   └── resources/
│   │   │       ├── application.properties  # Application configuration
│   │   │       ├── init.sql               # Database initialization
│   │   │       ├── schema.sql             # Database schema
│   │   │       └── data.sql               # Initial data
│   │   └── test/                # Test classes
│   ├── build.gradle            # Backend dependencies
│   └── gradlew                 # Gradle wrapper
│
├── tomcat/                     # Local Tomcat server
│   ├── bin/                   # Tomcat binaries (symlink)
│   ├── conf/                  # Tomcat configuration (symlink)
│   ├── lib/                   # Tomcat libraries (symlink)
│   ├── logs/                  # Application logs
│   ├── temp/                  # Temporary files
│   ├── webapps/              # Deployed applications
│   └── work/                 # Working directory
│
├── run-app.sh                 # Script to start both frontend and backend
├── start-tomcat.sh           # Script to start Tomcat
├── stop-tomcat.sh            # Script to stop Tomcat
└── README.md                 # Project documentation
```

Key Components:
- **Frontend**: React application with TypeScript, using modern React practices (hooks, contexts)
- **Backend**: Spring Boot application with JWT authentication and MySQL database
- **Tomcat**: External Tomcat server for production-like deployment
- **Scripts**: Helper scripts for managing the application lifecycle

## Prerequisites

- Java 21
- Node.js (managed via nvm)
- MySQL
- Gradle

## Setup Instructions

### Backend (Spring Boot)

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Build the project:
   ```bash
   ./gradlew build
   ```

3. Run the application:
   ```bash
   ./gradlew bootRun
   ```

   Find Tomcat process
   ps aux | grep tomcat
   pkill -f tomcat
   pkill -9 -f tomcat   (force kill)

The backend API will be available at `http://localhost:8080`Let me explain the key 


Differences between ./gradlew bootRun and ./start-tomcat.sh:
   ./gradlew bootRun:
      Uses Spring Boot's embedded Tomcat server
      Runs directly from the Spring Boot application
      Simpler to use but less configurable
      Good for development and testing
      Runs on the default Spring Boot port (8080)
      Managed by Spring Boot's lifecycle
   ./start-tomcat.sh:
      Uses an external, standalone Tomcat server
      More configurable (can modify server.xml, etc.)
      Better for production-like environments
      Allows multiple applications to run on the same Tomcat instance
      Can be configured with different ports, SSL, etc.
      Managed independently of the application




### Frontend (React)

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm start
   ```

   Find the all PID(processes) that are using port 3000
      lsof -i :3000

   Kill using the PID
      kill <PID>

The frontend application will be available at `http://localhost:3000`

## Features

- User authentication with JWT
- Secure password storage
- RESTful API endpoints
- React-based user interface

## Security

This application implements several security measures:
- JWT-based authentication
- Secure password hashing
- CORS configuration
- Spring Security implementation

## API Documentation

[API documentation will be added as endpoints are implemented]

# front-back-web
React frontend + REST backend app

A React frontend + REST backend web application using Spring Boot, MySQL, and Tomcat. The application provides user authentication functionality with secure password storage.

## Requirements

- Java 21 or newer
- MySQL 8.0.42 or newer
- Tomcat 9.0.0 or newer (installed via Homebrew)
- Gradle (included in wrapper)

   java --version && mysql --version && catalina version


## Project Overview

- Java-based web application using Spring Boot 3.2.3
- MySQL database for data persistence
- User authentication with encrypted passwords
- Standard Java project structure using Gradle
- External Tomcat deployment

## Password Validation

To verify the admin password hash is correctly set up:

1. The default admin credentials are:
   - Username: `admin`
   - Password: `admin123`

2. Run the password validation test:
   ```bash
   ./gradlew test --tests "com.example.basicweb.PasswordHashTest"
   ```
   This test verifies that the BCrypt hash in `data.sql` matches the password "admin123".

3. If you need to generate a new password hash, you can run:
   ```bash
   ./gradlew run -PmainClass=com.example.basicweb.util.PasswordHashGenerator
   ```
   This utility will generate new BCrypt hashes and verify them.

### Note on BCrypt Hashes

BCrypt intentionally generates different hash values for the same password. This is a security feature:
- Each hash includes a random salt to prevent rainbow table attacks
- The salt is automatically stored as part of the hash string
- Different hashes of the same password will all verify successfully
- Hash format: `$2a$10$...` where:
  - `$2a$` is the BCrypt version
  - `10` is the work factor
  - The rest contains the salt and hash combined

## Build and Development

### Gradle Commands

```bash
# Build the project
./gradlew build

# Build WAR file only
./gradlew war

# Clean build directory
./gradlew clean

# Run tests
./gradlew test

# Show project dependencies
./gradlew dependencies

# Build without running tests
./gradlew build -x test
```

### Build Configuration

The project uses Gradle 8.x with the following key configurations in `build.gradle`:

```groovy
plugins {
    id 'java'
    id 'war'
    id 'org.springframework.boot' version '3.2.3'
    id 'io.spring.dependency-management' version '1.1.4'
}

java {
    sourceCompatibility = JavaVersion.VERSION_21
    targetCompatibility = JavaVersion.VERSION_21
}
```

## Development Setup

1. **Install Required Software**
   ```bash
   # Install Java 21 (if not installed)
   brew install openjdk@21

   # Install MySQL
   brew install mysql@8.0

   # Install Tomcat
   brew install tomcat
   ```

2. **Configure Java**
   ```bash
   # Add Java to your PATH (add to your .zshrc or .bashrc)
   export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
   
   # Set JAVA_HOME (add to your .zshrc or .bashrc)
   export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
   ```

3. **Build and Deploy**
   ```bash
   # Build the WAR file
   ./gradlew war

   # Copy WAR to Tomcat webapps
   cp build/libs/basic-web-1.0-SNAPSHOT.war tomcat/webapps/basic-web.war
   ```

## Database Configuration

### Initial Database Setup

The database must be set up manually before running the application for the first time. Follow these steps:

 - **Create Database and User** (run as root)
 - **Create Tables** (run as sammy)
 - **Insert Initial Data** (optional, run as sammy)
   ```bash
   mysql -u root < src/main/resources/init.sql
   ```


### Database Management

- The application is configured to NOT modify the database schema automatically
- All database changes must be made manually using SQL scripts
- To reset the database:
  ```bash
  mysql -u root -e "DROP DATABASE basicwebdb;"
  ```
  Then follow the initial setup steps again


### Configuration Files

- **init.sql**: One-time database and user creation script
- **schema-init.sql**: Initial table creation script (run manually)
- **data.sql**: Initial data insertion script (run manually)
- **application.properties**: Database connection settings

### Key Configuration Properties

```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/basicwebdb
spring.datasource.username=sammy
spring.datasource.password=password123

# Prevent Automatic Schema Changes
spring.jpa.hibernate.ddl-auto=none
spring.sql.init.mode=never
```


