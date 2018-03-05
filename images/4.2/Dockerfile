FROM monogramm/docker-axelor-development-kit:4.1

LABEL maintainer="Mathieu BRUNOT <mathieu.brunot@monogramm.io>"

ENV AXELOR_HOME /opt/adk
ENV ABS_VERSION 4.2.3

# Test axelor-development-kit
RUN set -o errexit -o nounset; \
	echo "Testing Axelor Development Kit installation"; \
	echo "$AXELOR_HOME"; \
	axelor --version

# Switch to root
USER root

# Second stage: Get axelor-business-suite
RUN set -o errexit -o nounset ; \
	echo "Downloading Axelor Business Suite"; \
	wget -O abs.tar.gz https://github.com/axelor/axelor-business-suite/archive/v${ABS_VERSION}.tar.gz; \
	wget -O abs-webapp.tar.gz https://github.com/axelor/abs-webapp/archive/v${ABS_VERSION}.tar.gz; \
	\
	echo "Building Axelor Business Suite"; \
	tar -xzf abs-webapp.tar.gz; \
	rm abs-webapp.tar.gz; \
	mv "abs-webapp-${ABS_VERSION}" "/usr/src/abs-webapp"; \
	tar -xzf abs.tar.gz; \
	rm abs.tar.gz; \
	rm -rf /usr/src/abs-webapp/modules/abs; \
	mv "axelor-business-suite-${ABS_VERSION}" "/usr/src/abs-webapp/modules/abs"; \
	rm -rf "axelor-business-suite-${ABS_VERSION}"; \
	cd "/usr/src/abs-webapp"; \
	axelor build; \
	\
	echo "Preparing Axelor Business Suite"; \
	mv "/usr/src/abs-webapp/build/libs/abs-webapp-${ABS_VERSION}.war" "/tmp/abs.war"; \
	./gradlew clean


# Third stage: Deploy and configure the WAR for tomcat
FROM tomcat:8-jre8

COPY --from=0 /tmp/abs.war /tmp/abs.war


# Database settings
ENV AXEL_DB_DIALECT 'org.hibernate.dialect.PostgreSQLDialect'
ENV AXEL_DB_DRIVER 'org.postgresql.Driver'
ENV AXEL_DB_TYPE 'postgresql'
ENV AXEL_DB_HOST 'localhost'
ENV AXEL_DB_PORT '5432'
ENV AXEL_DB_NAME 'axelor-business-suite'
ENV AXEL_DB_USER ''
ENV AXEL_DB_PASSWORD ''

# link to be used with header logo
ENV AXEL_URL_ROOT 'http://localhost:8080'

# Set default language
ENV AXEL_LOCALE 'en'

# Set default CSS theme, for example `blue`
ENV AXEL_THEME 'theme-default'

# Application Mode: Set to 'dev' for development mode else 'prod'
ENV AXEL_MODE 'prod'

# Application Demo: whether to import demo data for the application
ENV AXEL_DEMO 'false'

# Date Format
ENV AXEL_DATE_FORMAT 'yyyy-MM-dd'

# Timezone
ENV AXEL_TIMEZONE 'UTC'


# CORS configuration


# TODO LDAP Configuration
# ENV AXEL_LDAP_URL 'ldap://localhost:389'
# ENV AXEL_LDAP_AUTH_TYPE 'simple'
# ENV AXEL_LDAP_ADMIN_LOGIN ''
# ENV AXEL_LDAP_ADMIN_PASS ''
# ENV AXEL_LDAP_USER_BASE ''
# ENV AXEL_LDAP_USER_FILTER '(uid={0})'
# ENV AXEL_LDAP_GROUP_BASE ''
# ENV AXEL_LDAP_GROUP_FILTER '(uniqueMember=uid={0})'
# ENV AXEL_LDAP_GROUP_CLASS ''



RUN set -ex; \
	echo "Installing needed packages"; \
	apt-get update -q; \
	# install the packages we need
	apt-get install -y --no-install-recommends \
		unzip xmlstarlet \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
	echo "Deploying Axelor Business Suite"; \
	unzip /tmp/abs.war -d $CATALINA_HOME/webapps/abs; \
	mv "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties.template"; \
	xmlstarlet ed \
		-P -S -L \
		-i '/Server/Service/Engine/Host/Valve' -t 'elem' -n 'Context' \
		-i '/Server/Service/Engine/Host/Context' -t 'attr' -n 'path' -v '/' \
		-i '/Server/Service/Engine/Host/Context[@path="/"]' -t 'attr' -n 'docBase' -v 'abs' \
		-s '/Server/Service/Engine/Host/Context[@path="/"]' -t 'elem' -n 'WatchedResource' -v 'WEB-INF/web.xml' \
		-i '/Server/Service/Engine/Host/Valve' -t 'elem' -n 'Context' \
		-i '/Server/Service/Engine/Host/Context[not(@path="/")]' -t 'attr' -n 'path' -v '/ROOT' \
		-s '/Server/Service/Engine/Host/Context[@path="/ROOT"]' -t 'attr' -n 'docBase' -v 'ROOT' \
		-s '/Server/Service/Engine/Host/Context[@path="/ROOT"]' -t 'elem' -n 'WatchedResource' -v 'WEB-INF/web.xml' \
	$CATALINA_HOME/conf/server.xml; \
	\
	echo "Cleaning Axelor Business Suite"; \
	rm -f /tmp/abs.war


VOLUME $CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties
VOLUME /srv/axelor/upload

EXPOSE 8080 8443

WORKDIR $CATALINA_HOME


# Copy entrypoint
COPY entrypoint.sh /
RUN set -ex; \
	chmod 755 /entrypoint.sh;

ENTRYPOINT ["/entrypoint.sh"]
CMD ["catalina.sh", "run"]

