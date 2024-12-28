FROM maven:3.9.9-eclipse-temurin-17-focal AS base


WORKDIR /home/workspace

# Copy all project files to the contaner:
COPY pom.xml .
COPY src ./src

# Compile and package the application:
RUN mvn install


# Use multistage to create image with the files necessary only
FROM openjdk:25-slim

# Define current version argument
ARG CUR_VERSION
ENV CURRENT_VERSION=$CUR_VERSION

# Copy the packaged java application:
COPY --from=base /home/workspace/target/my-app-${CURRENT_VERSION}.jar /home/workspace/target/my-app-${CURRENT_VERSION}.jar


# Run the application:
CMD ["java", "-jar", "/home/workspace/target/my-app-${CURRENT_VERSION}.jar"]
