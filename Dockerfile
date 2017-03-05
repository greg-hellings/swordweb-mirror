FROM fedora:25

# add tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.11

# https://issues.apache.org/jira/browse/INFRA-8753?focusedCommentId=14735394#comment-14735394
ENV TOMCAT_TGZ_URL https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
# not all the mirrors actually carry the .asc files :'(
ENV TOMCAT_ASC_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc

RUN set -x \
	\
	&& dnf install -y \
		wget \
		java-1.8.0-openjdk-headless \
		libicu \
		clucene-core \
		omniORB \
	&& wget -O tomcat.tar.gz "$TOMCAT_TGZ_URL" \
	&& wget -O tomcat.tar.gz.asc "$TOMCAT_ASC_URL" \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz* 

RUN rm -rf /usr/local/tomcat/webapps/ROOT/*
COPY webapp/ /usr/local/tomcat/webapps/ROOT/
COPY docker-template/context.xml /usr/local/tomcat/webapps/ROOT/META-INF/
COPY docker-template/log4j.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/
COPY docker-template/swordweb.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/
COPY docker-template/java.security /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/
COPY docker-template/swordorbserver /usr/bin/
COPY docker-template/sword.conf /etc/
COPY docker-template/sword-mods /usr/share/sword/
RUN { \
	echo '#!/bin/bash'; \
	echo '#if [[ -z $DEFAULTBIBLE || -z $LOGLEVEL ]]; then'; \
	echo "#  echo 'Missing either DEFAULTBIBLE, or LOGLEVEL.'"; \
	echo "#  echo 'example: docker run -e DEFAULTBIBLE=KJV -e LOGLEVEL=DEBUG crosswire/swordweb'"; \
	echo '#  exit 1'; \
	echo '#fi'; \
	echo 'if [[ -z $LOGLEVEL ]]; then'; \
	echo '  LOGLEVEL=INFO'; \
	echo 'fi'; \
	echo 'if [[ -z $DEFAULTBIBLE ]]; then'; \
	echo '  DEFAULTBIBLE=KJV'; \
	echo 'fi'; \
	echo 'sed -i "s!\$DEFAULTBIBLE!$DEFAULTBIBLE!g" "/usr/local/tomcat/webapps/ROOT/WEB-INF/swordweb.properties"'; \
	echo 'sed -i "s!\$LOGLEVEL!$LOGLEVEL!g" "/usr/local/tomcat/webapps/ROOT/WEB-INF/classes/log4j.properties"'; \
	tail -n +2 /usr/local/tomcat/bin/catalina.sh; \
	} > /usr/local/tomcat/bin/catalina.sh.new
RUN cat /usr/local/tomcat/bin/catalina.sh.new > /usr/local/tomcat/bin/catalina.sh

EXPOSE 8080 8009
CMD ["catalina.sh", "run"]
