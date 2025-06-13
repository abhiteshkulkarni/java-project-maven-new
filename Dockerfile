# Stage 1: Build the Java project with Maven
FROM maven:latest AS builder

# Set working directory inside the container
WORKDIR /app

# Copy pom.xml and download dependencies (layer caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Package the app (WAR or JAR)
RUN mvn clean package -DskipTests

# Stage 2: Run with Tomcat
FROM tomcat:10.1.20-jdk17-temurin AS runtime

# Clean out default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from builder stage
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port
EXPOSE 8080
