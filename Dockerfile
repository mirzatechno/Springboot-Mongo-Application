FROM eclipse-temurin:8-jdk-alpine

WORKDIR /opt/app

COPY target/spring-boot-mongo-1.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
