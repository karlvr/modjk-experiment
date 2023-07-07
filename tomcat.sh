#!/bin/bash -eux

TOMCAT_CONNECTORS_VERSION=1.2.48

# Install Tomcat connectors
mkdir /opt/src
wget --no-verbose http://archive.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-${TOMCAT_CONNECTORS_VERSION}-src.tar.gz -O /opt/src/tomcat-connectors-${TOMCAT_CONNECTORS_VERSION}-src.tar.gz
tar -C /opt/src -zxf /opt/src/tomcat-connectors-${TOMCAT_CONNECTORS_VERSION}-src.tar.gz

pushd /opt/src/tomcat-connectors-${TOMCAT_CONNECTORS_VERSION}-src/native
./configure --with-apxs=/usr/bin/apxs2
make clean && make
cp apache-2.0/mod_jk.so /usr/lib/apache2/modules
popd

cat > /etc/apache2/mods-available/jk.load <<EOF
LoadModule jk_module /usr/lib/apache2/modules/mod_jk.so
EOF

# The +ForwardDirectories is part of the issue
cat > /etc/apache2/mods-available/jk.conf <<EOF
JkWorkersFile /etc/apache2/workers.properties
JkOptions +ForwardDirectories
JkShmFile /var/log/apache2/jk-runtime-status
JkLogFile /var/log/apache2/mod_jk.log
JkLogLevel info
EOF

cat > /etc/apache2/workers.properties <<EOF
worker.list=status
worker.status.type=status
EOF

a2enmod jk
