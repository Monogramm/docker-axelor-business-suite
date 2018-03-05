#!/bin/bash
set -e

if [ ! -d /srv/axelor/upload ]; then
	mkdir -p /srv/axelor/upload
fi

# Setup the default AXELOR_CONFig
if [ ! -f "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties" ]; then
	echo "Setting up initial Axelor AXELOR_CONFig"
	cp "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties.template" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	sed -i "s|db.default.dialect = .*|db.default.dialect = ${DB_DIALECT}|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	sed -i "s|db.default.driver = .*|db.default.driver = ${DB_DRIVER}|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	sed -i "s|db.default.url = .*|db.default.url = ${DB_URL}|g" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	sed -i "s|db.default.user = .*|db.default.user = ${DB_USER}|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	sed -i "s|db.default.password = .*|db.default.password = ${DB_PASSWORD}|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	sed -i "s|application.home = .*|application.home = ${URL_ROOT}|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	sed -i "s|application.locale = .*|application.locale = ${LOCALE}|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	sed -i "s|application.theme = .*|application.theme = ${THEME}|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	sed -i "s|application.mode = .*|application.mode = ${MODE}|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	sed -i "s|data.import.demo-data = .*|data.import.demo-data = ${DEMO}|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	sed -i "s|date.format = .*|date.format = ${DATE_FORMAT}|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	sed -i "s|date.timezone = .*|date.timezone = ${TIMEZONE}|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	sed -i "s|file.upload.dir = .*|file.upload.dir = /srv/axelor/upload|" "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	echo "# ~~~~~" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "# DEMO Configuration" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "# ~~~~~" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "# disable demo data import" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "data.import.demo-data = false" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	echo "# ~~~~~" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "# CORS Configuration" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "# ~~~~~" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "# CORS settings to allow cross origin requests" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	echo "# regular expression to test allowed origin or * to allow all (not recommended)" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "#cors.allow.origin = *" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "#cors.allow.credentials = true" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "#cors.allow.methods = GET,PUT,POST,DELETE,HEAD,OPTIONS" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "#cors.allow.headers = Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	echo "# ~~~~~" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "# LDAP Configuration" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "# ~~~~~" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "ldap.server.url = ${LDAP_URL}" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	echo "# can be 'simple' or 'CRAM-MD5'" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "ldap.auth.type = ${LDAP_AUTH_TYPE}" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	echo "#ldap.system.user = ${LDAP_ADMIN_LOGIN}" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "#ldap.system.password = ${LDAP_ADMIN_PASS}" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	echo "# user search base" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "ldap.user.base = ${LDAP_USER_BASE}" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	echo "# a template to search user by user login id" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "ldap.user.filter = ${LDAP_USER_FILTER}" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	echo "# group search base" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "ldap.group.base = ${LDAP_GROUP_BASE}" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	echo "# a template to search groups by user login id" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "ldap.group.filter = ${LDAP_GROUP_FILTER}" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

	echo "# if set, create groups on ldap server under ldap.group.base" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
	echo "ldap.group.object.class = ${LDAP_GROUP_CLASS}" >>  "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"

fi

exec "$@"
