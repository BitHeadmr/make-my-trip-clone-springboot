# Use an official JDK image for building
FROM eclipse-temurin:17-jdk AS build

# Set working directory inside the container
WORKDIR /app

# Copy only the necessary files for dependency resolution
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Grant execute permission to the mvnw script
RUN chmod +x mvnw

# Download dependencies before adding the source code
RUN ./mvnw dependency:go-offline -B

# Copy the rest of the source code
COPY src src

# Build the application
RUN ./mvnw clean package -DskipTests

# Use a lighter runtime image
FROM eclipse-temurin:17-jre

# Set working directory
WORKDIR /app

# Copy only the built JAR file
COPY --from=build /app/target/makemytrip-*.jar app.jar

# Expose the port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
