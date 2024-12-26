# Stage 1: Clone the GitHub repository
FROM alpine/git as source-code

# Set the working directory
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/Pradeep-22/Jenkins.git .

# Checkout the main branch
RUN git checkout main

# Stage 2: Build the .war file using Maven
FROM maven:3.8.5-openjdk-17 as build

# Set the working directory
WORKDIR /build

# Copy the MyWebApp directory from Stage 1
COPY --from=source-code /app/MyWebApp /build

# Package the application into a .war file
RUN mvn clean package

# Stage 3: Deploy to Tomcat
FROM tomcat:9.0.98

# Copy the WAR file from Stage 2 to the Tomcat webapps directory
COPY --from=build /build/target/MyWebApp.war /usr/local/tomcat/webapps/MyWebApp.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
