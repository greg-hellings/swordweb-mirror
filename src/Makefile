TOMCAT_HOME=/usr/local/tomcat
instdir=../webapp

all: ${instdir}/WEB-INF/classes/org/crosswire/web/i18n/TranslateTag.class

${instdir}/WEB-INF/classes/org/crosswire/web/i18n/TranslateTag.class: org/crosswire/web/i18n/TranslateTag.java
	javac -classpath ${TOMCAT_HOME}/common/lib/jsp-api.jar:${TOMCAT_HOME}/common/lib/servlet-api.jar:${instdir}/WEB-INF/classes:${instdir}/WEB-INF/lib/greekconverter.jar -d ${instdir}/WEB-INF/classes -sourcepath . ./org/crosswire/web/i18n/*.java ./org/crosswire/web/util/*.java ./org/crosswire/swordweb/*.java

clean:
	rm -rf ${instdir}/WEB-INF/classes/org/crosswire/web/*
