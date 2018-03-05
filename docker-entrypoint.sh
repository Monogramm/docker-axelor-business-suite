#!/bin/bash
set -e

if [ ! -d /srv/axelor/upload ]; then
	mkdir -p /srv/axelor/upload
fi

# If no config provided in volume, setup a default config
if [ ! -f /srv/axelor/config/application.properties ]; then
	echo "Setting up initial Axelor config"
	cp "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties.template" /srv/axelor/config/application.properties

	sed -i "s|db.default.dialect = .*|db.default.dialect = ${DB_DIALECT}|" /srv/axelor/config/application.properties
	sed -i "s|db.default.driver = .*|db.default.driver = ${DB_DRIVER}|" /srv/axelor/config/application.properties
	sed -i "s|db.default.url = .*|db.default.url = jdbc:${DB_URL}|g" /srv/axelor/config/application.properties
	sed -i "s|db.default.user = .*|db.default.user = ${DB_USER}|" /srv/axelor/config/application.properties
	sed -i "s|db.default.password = .*|db.default.password = ${DB_PASSWORD}|" /srv/axelor/config/application.properties

	sed -i "s|application.home = .*|application.home = ${URL_ROOT}|" /srv/axelor/config/application.properties

	sed -i "s|application.locale = .*|application.locale = ${LOCALE}|" /srv/axelor/config/application.properties

	sed -i "s|application.theme = .*|application.theme = ${THEME}|" /srv/axelor/config/application.properties

	sed -i "s|application.mode = .*|application.mode = ${MODE}|" /srv/axelor/config/application.properties

	sed -i "s|data.import.demo-data = .*|data.import.demo-data = ${DEMO}|" /srv/axelor/config/application.properties

	sed -i "s|date.format = .*|date.format = ${DATE_FORMAT}|" /srv/axelor/config/application.properties

	sed -i "s|date.timezone = .*|date.timezone = ${TIMEZONE}|" /srv/axelor/config/application.properties

	sed -i "s|file.upload.dir = .*|file.upload.dir = /srv/axelor/upload|" /srv/axelor/config/application.properties

	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# DEMO Configuration" >>  /srv/axelor/config/application.properties
	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# disable demo data import" >>  /srv/axelor/config/application.properties
	echo "data.import.demo-data = false" >>  /srv/axelor/config/application.properties

	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# CORS Configuration" >>  /srv/axelor/config/application.properties
	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# CORS settings to allow cross origin requests" >>  /srv/axelor/config/application.properties

	echo "# regular expression to test allowed origin or * to allow all (not recommended)" >>  /srv/axelor/config/application.properties
	echo "#cors.allow.origin = *" >>  /srv/axelor/config/application.properties
	echo "#cors.allow.credentials = true" >>  /srv/axelor/config/application.properties
	echo "#cors.allow.methods = GET,PUT,POST,DELETE,HEAD,OPTIONS" >>  /srv/axelor/config/application.properties
	echo "#cors.allow.headers = Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers" >>  /srv/axelor/config/application.properties

	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# LDAP Configuration" >>  /srv/axelor/config/application.properties
	echo "# ~~~~~" >>  /srv/axelor/config/application.properties
	echo "# something like 'ldap://localhost:389'" >>  /srv/axelor/config/application.properties
	echo "ldap.server.url = ${LDAP_URL}" >>  /srv/axelor/config/application.properties

	echo "# can be 'simple' or 'CRAM-MD5'" >>  /srv/axelor/config/application.properties
	echo "ldap.auth.type = ${LDAP_AUTH_TYPE}" >>  /srv/axelor/config/application.properties

	echo "ldap.system.user = ${LDAP_ADMIN_LOGIN}" >>  /srv/axelor/config/application.properties
	echo "ldap.system.password = ${LDAP_ADMIN_PASS}" >>  /srv/axelor/config/application.properties

	echo "# user search base" >>  /srv/axelor/config/application.properties
	echo "ldap.user.base = ${LDAP_USER_BASE}" >>  /srv/axelor/config/application.properties

	echo "# a template to search user by user login id" >>  /srv/axelor/config/application.properties
	echo "ldap.user.filter = ${LDAP_USER_FILTER}" >>  /srv/axelor/config/application.properties

	echo "# group search base" >>  /srv/axelor/config/application.properties
	echo "ldap.group.base = ${LDAP_GROUP_BASE}" >>  /srv/axelor/config/application.properties

	echo "# a template to search groups by user login id" >>  /srv/axelor/config/application.properties
	echo "ldap.group.filter = ${LDAP_GROUP_FILTER}" >>  /srv/axelor/config/application.properties

	echo "# if set, create groups on ldap server under ldap.group.base" >>  /srv/axelor/config/application.properties
	echo "ldap.group.object.class = ${LDAP_GROUP_CLASS}" >>  /srv/axelor/config/application.properties

fi

# Erase existing config with the one in volume
if [ -f /srv/axelor/config/application.properties ]; then
	echo "Updating Axelor config"
	cp /srv/axelor/config/application.properties "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
fi

exec "$@"
