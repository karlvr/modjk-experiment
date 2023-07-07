#!/bin/bash -eux

# Disable all other sites
rm /etc/apache2/sites-enabled/*.conf

# Create a simple site config with no JkMounts or anything!
cat <<EOF >/etc/apache2/sites-enabled/test.conf
<VirtualHost *:80>
ServerName test
DocumentRoot /srv/www
</VirtualHost>
EOF

# We must disable the autoindex mod
# We are expressly told not to do that by a2dismod, but it is not automatically enabled
# after an upgrade from Ubuntu 18 to 20.
a2dismod -f autoindex

# We must require all granted the base dir
cat <<EOF >/etc/apache2/conf-enabled/test.conf
<Directory /srv/www/>
	Require all granted
</Directory>
EOF

# We must create the directory so are forbidden to list it
mkdir -p /srv/www/docs
