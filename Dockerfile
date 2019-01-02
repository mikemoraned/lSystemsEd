FROM openjdk:8-jre-alpine

ENV JETTY=jetty-runner-8.1.0.RC2.jar
ENV WAR=2011278Tn8-LSystems_2.8.1-0.6.1.war
ENV PORT=8000
ENV JAVA_OPTS=""

COPY $JETTY /$JETTY
COPY war/$WAR /$WAR

EXPOSE ${PORT}

CMD /usr/bin/java $JAVA_OPTS -jar /$JETTY --port $PORT /$WAR
