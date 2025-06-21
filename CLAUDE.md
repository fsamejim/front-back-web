# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a full-stack web application consisting of:
1. **Frontend**: React application with TypeScript, using React Router for navigation and JWT for authentication
2. **Backend**: Spring Boot 3.2.3 Java application with Spring Security, JPA, and JWT authentication
3. **Database**: MySQL database for data persistence

## Commands Reference

### Backend (Spring Boot) Commands

Run these commands from the `backend/` directory:

```bash
# Build the project
./gradlew build

# Run the Spring Boot application directly
./gradlew bootRun

# Build WAR file only
./gradlew war

# Run tests
./gradlew test

# Run specific test
./gradlew test --tests "com.example.frontbackweb.PasswordHashTest"

# Generate password hash
./gradlew run -PmainClass=com.example.frontbackweb.util.PasswordHashGenerator

# Clean build directory
./gradlew clean

# Show project dependencies
./gradlew dependencies

# Build without running tests
./gradlew build -x test
```

### Frontend (React) Commands

Run these commands from the `frontend/` directory:

```bash
# Install dependencies
npm install

# Start development server
npm start

# Run tests
npm test

# Build for production
npm run build
```

### Tomcat Deployment Commands

Run these commands from the root directory:

```bash
# Setup local Tomcat environment
./setup-tomcat.sh

# Start Tomcat
./start-tomcat.sh

# Stop Tomcat
./stop-tomcat.sh

# Deploy WAR file to Tomcat
cp backend/build/libs/front-back-web-1.0-SNAPSHOT.war tomcat/webapps/front-back-web.war
```

### Database Commands

```bash
# Initialize database (one-time setup)
mysql -u root < backend/src/main/resources/init.sql

# Reset database if needed
mysql -u root -e "DROP DATABASE frontbackwebdb;"
```

## Architecture Overview

### Authentication Flow

1. **Frontend Authentication**: The frontend uses React Context (AuthContext) to manage authentication state
   - JWT tokens are stored in localStorage
   - Protected routes require authentication
   - Authentication state is maintained across page refreshes

2. **Backend Security**: The backend uses Spring Security with JWT for authentication
   - JWT tokens are generated on login/register
   - Tokens are validated for protected endpoints
   - User passwords are encrypted with BCrypt

3. **API Endpoints**:
   - `/api/auth/login`: Authenticate user and return JWT
   - `/api/auth/register`: Register new user and return JWT
   - `/api/auth/me`: Get current user information (requires authentication)

### Component Structure

1. **Frontend**:
   - React components in `/frontend/src/components/`
   - Authentication context in `/frontend/src/contexts/AuthContext.tsx`
   - API services in `/frontend/src/services/`
   - Type definitions in `/frontend/src/types/`

2. **Backend**:
   - Java controllers in `/backend/src/main/java/com/example/frontbackweb/controller/`
   - Models in `/backend/src/main/java/com/example/frontbackweb/model/`
   - Security configuration in `/backend/src/main/java/com/example/frontbackweb/config/`
   - JWT implementation in `/backend/src/main/java/com/example/frontbackweb/security/`

## Database Configuration

The application uses a MySQL database with the following configuration:
- Database name: `frontbackwebdb`
- Username: `sammy`
- Password: `password123`
- Connection URL: `jdbc:mysql://localhost:3306/frontbackwebdb`

The database schema is managed manually, not through Hibernate's auto-generation.

## Development Environment

- Java 21 or newer
- Node.js (latest LTS version)
- MySQL 8.0.42 or newer
- Tomcat 9.0.0 or newer (installed via Homebrew)