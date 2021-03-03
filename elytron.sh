#!/usr/bin/env bash
declare elytron_iteration 25
declare elytron_salt=$(openssl rand -base64 32| head -c 8 )
declare elytron_creds=$(openssl rand -base64 32)
#declare EAP_HOME=/opt/wildfly/wildfly-14
x=$(/opt/wildfly/wildfly-14/bin/elytron-tool.sh mask --salt ${elytron_salt} --iteration 123 --secret ${elytron_creds})
echo "$x"
