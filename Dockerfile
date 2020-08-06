FROM openjdk:11
COPY ./target/*.jar /zuul.jar
EXPOSE 8400
ENTRYPOINT ["java", "-jar", "zuul.jar"]