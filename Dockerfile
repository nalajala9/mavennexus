FROM tomcat:8.0.51-jre8-alpine
COPY ./target/*.jar /usr/local/tomcat/webapps/

