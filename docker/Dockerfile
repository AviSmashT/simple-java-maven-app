FROM maven:3.9.0-eclipse-temurin-19 AS base


WORKDIR /home/workspace

# Copy all project files to the contaner:
COPY . .


# Compile and package the application:
RUN mvn clean compile package


# Use multistage to create image with the files necessary only
FROM ibmjava:jre


# Copy the packaged java application:
COPY --from=base /home/workspace/target/*.jar /home/workspace/target/program.jar


# Run the application:
CMD ["java", "-cp", "/home/workspace/target/program.jar"]
