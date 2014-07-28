#!/bin/sh

# Reboot a Cisco EPC3208G using the HTTP protocol.
#
# Using curl(1) this script performs the necessary login on the router
# and requests a reset.  Both the administrator user name (usually
# "admin") and its password must be provided on the command line,
# together with the hostname or IP address of the router.

[ $# -lt 3 ] && {
    cat <<EOF
usage: $0 host admin_user password [curl_option ...]

Reboot a Cisco EPC3208G cable modem via HTTP.

This script can be also used within a cron job such as the following:

*/5 * * * * /sbin/ping -t 10 -q -o your.isp.host >/dev/null || reset_router 192.168.0.1 admin XXXXX

This checks every 5 minutes if the nearest host outside your LAN is
reachable. If not, assume the connection is hung and thus reboot the
cable modem.  Make sure that you choose an interval that is longer
than the time the router takes to reboot and get the configuration
from your ISP, or you may get cought in an endless loop of reboots.

To debug you may want to add at the end of the command line the curl
options "-v" or "--trace -". See curl(1) for details.

EOF
    exit 1
}

host=$1
user=$2
password="$3"
shift;shift;shift
curl_options="$@"

JAR=/tmp/cookie_jar.$$
CURL="curl -s -o /dev/null -b ${JAR} -c ${JAR} -L $curl_options"

trap 'rm -f $JAR' 0 1 2 3 15

${CURL} -e http://${host}/Docsis_system.asp -d username_login=${user} -d password_login="${password}" -d LanguageSelect=en -d Language_Submit=0 -d login=Log+In http://${host}/goform/Docsis_system

${CURL} -e http://${host}/Devicerestart.asp -d devicerestrat_Password_check="${password}" -d mtenRestore=Device+Restart -d devicerestart=1 -d devicerestrat_getUsercheck=true http://${host}/goform/Devicerestart
