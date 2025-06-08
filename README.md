# Basic Web Application

A basic web application using Spring Boot, MySQL, and Tomcat. The application provides user authentication functionality with secure password storage.

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

## Project Structure

```
src/main/
├── java/com/example/basicweb/
│   ├── BasicWebApplication.java
│   ├── config/
│   │   └── SecurityConfig.java
│   ├── controller/
│   │   └── AuthController.java
│   ├── model/
│   │   └── User.java
│   ├── repository/
│   │   └── UserRepository.java
│   └── service/
│       └── UserService.java
├── resources/
│   ├── application.properties
│   ├── init.sql
│   ├── schema.sql
│   ├── data.sql
│   └── templates/
│       ├── login.html
│       ├── register.html
│       └── home.html
```

## Running the Application

1. **Setup Tomcat Environment**
   ```bash
   ./setup-tomcat.sh
   ```

2. **Build and Deploy**
   ```bash
   ./gradlew war
   cp build/libs/basic-web-1.0-SNAPSHOT.war tomcat/webapps/basic-web.war
   ```

3. **Start Tomcat**
   ```bash
   ./start-tomcat.sh
   ```

4. Access the application at: http://localhost:8080/basic-web

5. **Stop Tomcat** (when needed)
   ```bash
   ./stop-tomcat.sh
   ```

## Security Features

- Password encryption using BCrypt
- Form-based authentication
- Session management
- Protected endpoints

## Getting Started

1. **Database Setup**
   ```bash
   mysql -u root < src/main/resources/init.sql
   ```

2. **Application Properties**
   - Database URL: jdbc:mysql://localhost:3306/basicwebdb
   - Username: sammy
   - Password: password123

3. **Build and Run**
   ```bash
   ./gradlew bootRun
   ```

4. **Access the Application**
   - URL: http://localhost:8080/basic-web
   - Default admin credentials:
     - Username: admin
     - Password: admin123

## Local Tomcat Setup

For development, it's recommended to use a local Tomcat setup instead of the global Homebrew installation. This allows for isolated testing and development.

1. **Create Local Tomcat Directory Structure**
   ```bash
   # Create basic directory structure
   mkdir -p tomcat/webapps tomcat/logs tomcat/temp tomcat/work
   ```

2. **Create Symbolic Links to Tomcat Resources**
   ```bash
   # Link to Tomcat's binary files
   ln -s /opt/homebrew/Cellar/tomcat/11.0.7/libexec/bin tomcat/bin
   
   # Link to Tomcat's library files
   ln -s /opt/homebrew/Cellar/tomcat/11.0.7/libexec/lib tomcat/lib
   
   # Link to Tomcat's configuration
   ln -s /opt/homebrew/Cellar/tomcat/11.0.7/libexec/conf tomcat/conf
   ```

3. **Verify Directory Structure**
   ```bash
   ls -la tomcat/
   # Should show:
   # bin -> /opt/homebrew/Cellar/tomcat/11.0.7/libexec/bin
   # conf -> /opt/homebrew/Cellar/tomcat/11.0.7/libexec/conf
   # lib -> /opt/homebrew/Cellar/tomcat/11.0.7/libexec/lib
   # logs/
   # temp/
   # webapps/
   # work/
   ```

4. **Deploy Application**
   ```bash
   # Build the application
   ./gradlew clean build
   
   # Copy WAR to local Tomcat webapps
   cp build/libs/basic-web-1.0-SNAPSHOT.war tomcat/webapps/basic-web.war
   ```

5. **Start/Stop Tomcat**
   ```bash
   # Start Tomcat
   tomcat/bin/startup.sh
   
   # Stop Tomcat
   tomcat/bin/shutdown.sh
   
   # View logs
   tail -f tomcat/logs/catalina.out
   ```

The application will be available at: http://localhost:8080/basic-web

### Note on Directory Structure
```
tomcat/
├── bin/ -> symbolic link to Tomcat binaries
├── conf/ -> symbolic link to Tomcat configuration
├── lib/ -> symbolic link to Tomcat libraries
├── logs/ -> local logs directory
├── temp/ -> local temp directory
├── webapps/ -> local webapps directory
└── work/ -> local work directory
```

This setup provides an isolated environment for testing and development, while still using the Homebrew-installed Tomcat binaries and libraries.

