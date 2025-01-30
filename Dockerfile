# Use an official Maven image with JDK for building
FROM maven:3.9.5-eclipse-temurin-23 AS build

WORKDIR /app
COPY . .

# Build the application
RUN mvn clean package -DskipTests

# Use a lighter runtime image
FROM eclipse-temurin:23-jre

WORKDIR /app

# Copy only the built JAR file
COPY --from=build /app/target/makemytrip-*.jar app.jar

# Expose the port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
