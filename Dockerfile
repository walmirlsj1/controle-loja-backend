#FROM amazoncorretto:11-alpine-jdk as openjdk
##FROM openjdk:8-jdk-alpine
#
##RUN addgroup -S spring && adduser -S spring -G spring
##USER spring:spring
## ----
## Install Maven
#RUN apk add --no-cache curl tar bash
#
#ARG MAVEN_VERSION=3.8.1
#ARG USER_HOME_DIR="/root"
#ARG SHA=0ec48eb515d93f8515d4abe465570dfded6fa13a3ceb9aab8031428442d9912ec20f066b2afbf56964ffe1ceb56f80321b50db73cf77a0e2445ad0211fb8e38d
##https://downloads.apache.org/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz
#ARG BASE_URL=https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries
#
#RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
#  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
#  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
#  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
#  && rm -f /tmp/apache-maven.tar.gz \
#  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
#
#ENV MAVEN_HOME /usr/share/maven
#ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
## speed up Maven JVM a bit
##ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
##ENTRYPOINT ["/usr/bin/mvn"]
#
#COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
#COPY settings-docker.xml /usr/share/maven/ref/
#
#RUN chmod +x /usr/local/bin/mvn-entrypoint.sh
#
#ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
#CMD ["mvn"]
#
## ----
## Install project dependencies and keep sources
## make source folder
#RUN mkdir -p /usr/src/app
#WORKDIR /usr/src/app
## copy other source files (keep in image)
#COPY src /usr/src/app/src
#
## install maven dependency packages (keep in image)
#COPY pom.xml /usr/src/app
#RUN mvn -T 1C install && rm -rf target

#
# Build stage
#
#FROM maven:3.8.1-amazoncorretto-11 AS build
#COPY src /home/app/src
#COPY pom.xml /home/app
#RUN mvn -f /home/app/pom.xml clean package

FROM amazoncorretto:11-alpine-jdk as openjdk

VOLUME /tmp
ARG JAR_FILE
ENV _JAVA_OPTIONS "-Xms256m -Xmx512m -Djava.awt.headless=true -Djava.library.path=./lib"
COPY ${JAR_FILE} /app/app.jar

WORKDIR /app
USER bootapp
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.jar", "com.devapp.loja.LojaApplication"]