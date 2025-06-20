# Full Stack Web Application

A full-stack web application with React frontend and Spring Boot backend, featuring user authentication and registration functionality.

## Important Note: Cursor IDE Integration

When running the application in Cursor IDE, be aware of the Java extension's behavior:
1. The Java extension auto-manages Spring Boot applications
2. It may detect and shut down manual Tomcat processes to prevent "conflicts"
3. This can cause issues with the application startup

Solutions for development:
1. Use the provided `run-app.sh` script which:
   - Starts Tomcat in a separate terminal
   - Starts React frontend in another terminal
   - Avoids Cursor's Java extension interference
2. Or disable Java auto-management in Cursor settings
3. Or use Cursor's run configurations instead of manual scripts

## Project Structure

```
front-back-web/
├── frontend/                    # React frontend application
│   ├── src/
│   │   ├── components/         # React components
│   │   │   ├── auth/          # Authentication components
│   │   │   │   ├── Login.tsx  # Login page with registration link
│   │   │   │   ├── Register.tsx # Registration page
│   │   │   │   └── ProtectedRoute.tsx # Route protection
│   │   │   └── common/        # Shared components
│   │   ├── contexts/          # React contexts
│   │   │   └── AuthContext.tsx # Authentication context
│   │   ├── services/          # API services
│   │   │   └── authService.ts # Authentication API calls
│   │   ├── types/             # TypeScript types
│   │   │   └── auth.ts        # Authentication types
│   │   └── App.tsx           # Main application component
│   └── package.json          # Frontend dependencies
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

## Features

- User authentication with JWT
- User registration with email verification
- Secure password storage using BCrypt
- Protected routes in frontend
- RESTful API endpoints
- React-based user interface with Material-UI
- MySQL database for data persistence
- External Tomcat deployment

## Quick Start

1. Start the application using the run script:
   ```bash
   ./run-app.sh
   ```
   This will:
   - Start Tomcat server in one terminal
   - Start React frontend in another terminal

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8080/basic-web/api

3. Default admin credentials:
   - Username: `admin`
   - Password: `admin123`

## Development Setup

### Frontend (React)

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install dependencies (only needed first time or when dependencies change):
   ```bash
   npm install
   ```

3. Clean and build the production version:
   ```bash
   # Remove the old build
   rm -rf build/
   # Create new production build
   npm run build
   ```

4. Start the development server:
   ```bash
   npm start
   ```

### Backend (Spring Boot)

1. Navigate to the backend directory:
   ```bash
   cd backend
   ./gradlew clean
   ```

2. Build the project:
   ```bash
   ./gradlew build
   ```

3. Deploy to Tomcat:
   ```bash
   ./gradlew war
   cp build/libs/basic-web-1.0-SNAPSHOT.war ../tomcat/webapps/basic-web.war
   ```

## Authentication Flow

1. **Registration**:
   - User clicks "Register here" on login page
   - Enters username, email, and password
   - On successful registration, redirected to login page

2. **Login**:
   - User enters credentials
   - JWT token is stored in localStorage
   - User is redirected to dashboard

3. **Protected Routes**:
   - Routes are protected using `ProtectedRoute` component
   - Unauthenticated users are redirected to login
   - JWT token is validated on each request

## Troubleshooting

### Tomcat Issues
If Tomcat fails to start:
```bash
# Check Tomcat process
ps aux | grep tomcat

# Kill Tomcat process
pkill -f tomcat
# or force kill
pkill -9 -f tomcat
```

### Frontend Issues
If React development server fails:
```bash
# Check processes using port 3000
lsof -i :3000

# Kill the process
kill <PID>
```

## Prerequisites

- Java 21
- Node.js (managed via nvm)
- MySQL
- Gradle



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



