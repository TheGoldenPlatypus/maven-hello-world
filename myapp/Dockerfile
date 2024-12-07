FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /app
ARG VERSION
COPY . .
RUN mvn package

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar ./app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
USER 1000