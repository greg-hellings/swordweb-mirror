TOMCAT_HOME=/usr/local/tomcat
instdir=..
all: ../WEB-INF/classes/org/crosswire/web/i18n/TranslateTag.class

../WEB-INF/classes/org/crosswire/web/i18n/TranslateTag.class: org/crosswire/web/i18n/TranslateTag.java
	javac -classpath ${TOMCAT_HOME}/common/lib/jsp-api.jar:${TOMCAT_HOME}/common/lib/servlet-api.jar -d ../WEB-INF/classes -sourcepath . ./org/crosswire/web/i18n/*.java ./org/crosswire/web/util/*.java

clean:
	rm -rf ../WEB-INF/classes/org/crosswire/web/*
