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
# We are expressly told not to do that by a2dismod, but it's possible, and it's recommended
# by CIS, see https://www.tenable.com/audits/items/CIS_Apache_HTTP_Server_2.4_Benchmark_v2.0.0_Level_1.audit:7089644969c33c9ce954a0e77ef3046e
a2dismod -f autoindex

# We must require all granted the base dir
cat <<EOF >/etc/apache2/conf-enabled/test.conf
<Directory /srv/www/>
	Require all granted
</Directory>
EOF

# We must create the directory so are forbidden to list it
mkdir -p /srv/www/docs
