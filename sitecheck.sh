
#!/bin/bash
#Written By:Raju John---DRE Ops
#Cross site check every 10 minutes


ALERTGROUP="DRE BELL"
ALERTKEY="Cross site alert"
ALERT_TEXT="Cross site is disabled. Inform DRE Ops at 813-414-4675"
SEVERITY=4

netcool ()
{
echo "NC_RICH_ALARM Node=${HOSTNAME}/Node AlertGroup=${ALERTGROUP}/AlertGroup AlertKey=${ALERTKEY}/AlertKey Type=1/Type Severity=${SEVERITY}/Severity Summary=${ALERT_TEXT}/Summary NOCVisible=1/NOCVisible AlrmOwnGrpContact=dre_ops@syniverse.com/AlrmOwnGrpContact Product=DRE/Product" >> /dev/tcp/10.12.7.15/7976
}

crosssite=` grep SDP_IS_REDUNDANT_ENABLED /app/dre/thirdparty/apache-tomcat-9.0.10/webapps/SDPv2.0/WEB-INF/classes/HotUpdate.conf | awk -F = '{print $2}' | tr -d '\r' `

case $crosssite in
        (true) echo "Cross site enabled";;
        (false) echo "Cross site disabled"
                netcool;;
        (*) echo "Cross site damaged"
                netcool;;
esac
