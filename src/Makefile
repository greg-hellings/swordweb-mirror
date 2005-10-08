TOMCAT_HOME=/usr/local/tomcat
#TOMCAT_HOME=/usr/share/tomcat5
instdir=..
all: ../WEB-INF/classes/org/crosswire/web/i18n/TranslateTag.class
	javac -Xlint -Xlint:unchecked:deprecation -classpath ../WEB-INF/classes/ -d ../WEB-INF/classes/ ./org/crosswire/swordweb/*.java
	
../WEB-INF/classes/org/crosswire/web/i18n/TranslateTag.class: org/crosswire/web/i18n/TranslateTag.java
	javac -classpath ${TOMCAT_HOME}/common/lib/jsp-api.jar:${TOMCAT_HOME}/common/lib/servlet-api.jar -d ../WEB-INF/classes -sourcepath . ./org/crosswire/web/i18n/*.java ./org/crosswire/web/util/*.java

clean:
	rm -rf ../WEB-INF/classes/org/crosswire/web/*
