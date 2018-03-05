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

	sed -i "s|db.default.dialect = .*|db.default.dialect = ${DB_DIALECT}|" $AXELOR_CONF
	sed -i "s|db.default.driver = .*|db.default.driver = ${DB_DRIVER}|" $AXELOR_CONF
	sed -i "s|db.default.url = .*|db.default.url = ${DB_URL}|g" $AXELOR_CONF
	sed -i "s|db.default.user = .*|db.default.user = ${DB_USER}|" $AXELOR_CONF
	sed -i "s|db.default.password = .*|db.default.password = ${DB_PASSWORD}|" $AXELOR_CONF

	sed -i "s|application.home = .*|application.home = ${URL_ROOT}|" $AXELOR_CONF

	sed -i "s|application.locale = .*|application.locale = ${LOCALE}|" $AXELOR_CONF

	sed -i "s|application.theme = .*|application.theme = ${THEME}|" $AXELOR_CONF

	sed -i "s|application.mode = .*|application.mode = ${MODE}|" $AXELOR_CONF

	sed -i "s|data.import.demo-data = .*|data.import.demo-data = ${DEMO}|" $AXELOR_CONF

	sed -i "s|date.format = .*|date.format = ${DATE_FORMAT}|" $AXELOR_CONF

	sed -i "s|date.timezone = .*|date.timezone = ${TIMEZONE}|" $AXELOR_CONF

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
	echo "ldap.server.url = ${LDAP_URL}" >>  $AXELOR_CONF

	echo "# can be 'simple' or 'CRAM-MD5'" >>  $AXELOR_CONF
	echo "ldap.auth.type = ${LDAP_AUTH_TYPE}" >>  $AXELOR_CONF

	echo "#ldap.system.user = ${LDAP_ADMIN_LOGIN}" >>  $AXELOR_CONF
	echo "#ldap.system.password = ${LDAP_ADMIN_PASS}" >>  $AXELOR_CONF

	echo "# user search base" >>  $AXELOR_CONF
	echo "ldap.user.base = ${LDAP_USER_BASE}" >>  $AXELOR_CONF

	echo "# a template to search user by user login id" >>  $AXELOR_CONF
	echo "ldap.user.filter = ${LDAP_USER_FILTER}" >>  $AXELOR_CONF

	echo "# group search base" >>  $AXELOR_CONF
	echo "ldap.group.base = ${LDAP_GROUP_BASE}" >>  $AXELOR_CONF

	echo "# a template to search groups by user login id" >>  $AXELOR_CONF
	echo "ldap.group.filter = ${LDAP_GROUP_FILTER}" >>  $AXELOR_CONF

	echo "# if set, create groups on ldap server under ldap.group.base" >>  $AXELOR_CONF
	echo "ldap.group.object.class = ${LDAP_GROUP_CLASS}" >>  $AXELOR_CONF

fi

exec "$@"
