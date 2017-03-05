TOMCAT_HOME=~/opt/tomcat
instdir=../webapp

all: ${instdir}/WEB-INF/classes/org/crosswire/swordweb/PerseusUtils.class

${instdir}/WEB-INF/classes/org/crosswire/swordweb/PerseusUtils.class: org/crosswire/swordweb/PerseusUtils.java
	javac -classpath ${TOMCAT_HOME}/common/lib/jsp-api.jar:${TOMCAT_HOME}/common/lib/servlet-api.jar:${instdir}/WEB-INF/classes:${instdir}/WEB-INF/lib/greekconverter.jar:${instdir}/WEB-INF/lib/crosswire.jar -d ${instdir}/WEB-INF/classes -sourcepath . ./org/crosswire/swordweb/*.java

clean:
	rm -rf ${instdir}/WEB-INF/classes/org/crosswire/swordweb/*
