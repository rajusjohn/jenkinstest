#!/bin/bash
#Written by Raju John-DRE Ops
#To check whether handler errors---every 3 minute

ALERTGROUP="DRE BELL"
ALERTKEY="Handler error alert"
ALERT_TEXT="Inform DRE Ops.Capture couple of thread dump,jstack trace and bounce the SDP/NMN Pair"
SEVERITY=5

netcool ()
{
echo "NC_RICH_ALARM Node=${HOSTNAME}/Node AlertGroup=${ALERTGROUP}/AlertGroup AlertKey=${ALERTKEY}/AlertKey Type=1/Type Severity=${SEVERITY}/Severity Summary=${ALERT_TEXT}/Summary NOCVisible=1/NOCVisible AlrmOwnGrpContact=dre_ops@syniverse.com/AlrmOwnGrpContact Product=DRE/Product" >> /dev/tcp/10.12.7.15/7976
}


CMD=` grep "Caused by: java.io.FileNotFoundException:"  /app/logs/server.log | grep "(Too many open files)" `
#echo $CMD

if [[ $CMD ]]; then
        echo "issue";
        netcool
else
        echo "no issue";
fi
