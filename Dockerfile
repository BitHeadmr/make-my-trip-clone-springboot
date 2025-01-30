# Use an official JDK image for building
FROM eclipse-temurin:17-jdk AS build

COPY . .
RUN mvn clean package -DskipTests

# Use a lighter runtime image
FROM eclipse-temurin:17-jre


# Copy only the built JAR file
COPY --from=build /app/target/makemytrip-*.jar app.jar

# Expose the port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
