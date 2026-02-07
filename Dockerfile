# Stage 1: build
FROM maven:3.9.0-amazoncorretto-17 AS build
WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: runtime
FROM eclipse-temurin:17-jre-focal
WORKDIR /app

COPY --from=build /build/target/demo-0.0.1-SNAPSHOT.jar app.jar

CMD ["java", "-jar", "app.jar"]

