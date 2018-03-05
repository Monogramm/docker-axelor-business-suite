#!/bin/bash
set -e

if [ ! -d /srv/axelor/upload ]; then
	mkdir -p /srv/axelor/upload
fi

# Setup the default AXELOR_CONFig
AXELOR_CONF = "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties"
if [ ! -f $AXELOR_CONF ]; then
	echo "Setting up initial Axelor AXELOR_CONFig"
	cp "$CATALINA_HOME/webapps/abs/WEB-INF/classes/application.properties.template" "$AXELOR_CONF"

	sed -i "s|db.default.dialect = .*|db.default.dialect = ${AXEL_DB_DIALECT}|" $AXELOR_CONF
	sed -i "s|db.default.driver = .*|db.default.driver = ${AXEL_DB_DRIVER}|" $AXELOR_CONF
	sed -i "s|db.default.url = .*|db.default.url = jdbc:${AXEL_DB_TYPE}://${AXEL_DB_HOST}:${AXEL_DB_PORT}/${AXEL_DB_NAME}|g" $AXELOR_CONF
	sed -i "s|db.default.user = .*|db.default.user = ${AXEL_DB_USER}|" $AXELOR_CONF
	sed -i "s|db.default.password = .*|db.default.password = ${AXEL_DB_PASSWORD}|" $AXELOR_CONF

	sed -i "s|application.home = .*|application.home = ${AXEL_URL_ROOT}|" $AXELOR_CONF

	sed -i "s|application.locale = .*|application.locale = ${AXEL_LOCALE}|" $AXELOR_CONF

	sed -i "s|application.theme = .*|application.theme = ${AXEL_THEME}|" $AXELOR_CONF

	sed -i "s|application.mode = .*|application.mode = ${AXEL_MODE}|" $AXELOR_CONF

	sed -i "s|data.import.demo-data = .*|data.import.demo-data = ${AXEL_DEMO}|" $AXELOR_CONF

	sed -i "s|date.format = .*|date.format = ${AXEL_DATE_FORMAT}|" $AXELOR_CONF

	sed -i "s|date.timezone = .*|date.timezone = ${AXEL_TIMEZONE}|" $AXELOR_CONF

	sed -i "s|file.upload.dir = .*|file.upload.dir = /srv/axelor/upload|" $AXELOR_CONF

	echo "# ~~~~~" >>  $AXELOR_CONF
	echo "# DEMO Configuration" >>  $AXELOR_CONF
	echo "# ~~~~~" >>  $AXELOR_CONF
	echo "# disable demo data import" >>  $AXELOR_CONF
	echo "data.import.demo-data = false" >>  $AXELOR_CONF

	echo "# ~~~~~" >>  $AXELOR_CONF
	echo "# CORS Configuration" >>  $AXELOR_CONF
	echo "# ~~~~~" >>  $AXELOR_CONF
	echo "# CORS settings to allow cross origin requests" >>  $AXELOR_CONF

	echo "# regular expression to test allowed origin or * to allow all (not recommended)" >>  $AXELOR_CONF
	echo "#cors.allow.origin = *" >>  $AXELOR_CONF
	echo "#cors.allow.credentials = true" >>  $AXELOR_CONF
	echo "#cors.allow.methods = GET,PUT,POST,DELETE,HEAD,OPTIONS" >>  $AXELOR_CONF
	echo "#cors.allow.headers = Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers" >>  $AXELOR_CONF

	echo "# ~~~~~" >>  $AXELOR_CONF
	echo "# LDAP Configuration" >>  $AXELOR_CONF
	echo "# ~~~~~" >>  $AXELOR_CONF
	echo "ldap.server.url = ${AXEL_LDAP_URL}" >>  $AXELOR_CONF

	echo "# can be 'simple' or 'CRAM-MD5'" >>  $AXELOR_CONF
	echo "ldap.auth.type = ${AXEL_LDAP_AUTH_TYPE}" >>  $AXELOR_CONF

	echo "#ldap.system.user = ${AXEL_LDAP_ADMIN_LOGIN}" >>  $AXELOR_CONF
	echo "#ldap.system.password = ${AXEL_LDAP_ADMIN_PASS}" >>  $AXELOR_CONF

	echo "# user search base" >>  $AXELOR_CONF
	echo "ldap.user.base = ${AXEL_LDAP_USER_BASE}" >>  $AXELOR_CONF

	echo "# a template to search user by user login id" >>  $AXELOR_CONF
	echo "ldap.user.filter = ${AXEL_LDAP_USER_FILTER}" >>  $AXELOR_CONF

	echo "# group search base" >>  $AXELOR_CONF
	echo "ldap.group.base = ${AXEL_LDAP_GROUP_BASE}" >>  $AXELOR_CONF

	echo "# a template to search groups by user login id" >>  $AXELOR_CONF
	echo "ldap.group.filter = ${AXEL_LDAP_GROUP_FILTER}" >>  $AXELOR_CONF

	echo "# if set, create groups on ldap server under ldap.group.base" >>  $AXELOR_CONF
	echo "ldap.group.object.class = ${AXEL_LDAP_GROUP_CLASS}" >>  $AXELOR_CONF

fi

exec "$@"
