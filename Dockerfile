FROM openjdk:11
COPY ./target/routing-and-filtering-gateway-0.0.1-SNAPSHOT.jar /zuul.jar
EXPOSE 8400
ENTRYPOINT ["java", "-jar", "zuul.jar"]