FROM tomcat:8.0.20-jre8
COPY target/sample-web-application*.war /usr/local/tomcat/webapps/sample-web-application.war
