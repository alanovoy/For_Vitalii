FROM openjdk:8-oraclelinux7
  WORKDIR /app
  COPY ./spring-petclinic-0.2-SNAPSHOT.jar /app
  EXPOSE 8080
  ENTRYPOINT ["java", "-jar","./spring-petclinic-0.2-SNAPSHOT.jar" ]

