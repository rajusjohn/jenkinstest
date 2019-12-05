
#!/bin/bash
#Written by Raju John-DRE Ops
#To check whether trigger request are coming

ALERTGROUP="DRE BELL"
ALERTKEY="Trigger request alert"
ALERT_TEXT="Trigger requests are not receiving. Notify DRE Ops"
SEVERITY=4

netcool ()
{
echo "NC_RICH_ALARM Node=${HOSTNAME}/Node AlertGroup=${ALERTGROUP}/AlertGroup AlertKey=${ALERTKEY}/AlertKey Type=1/Type Severity=${SEVERITY}/Severity Summary=${ALERT_TEXT}/Summary NOCVisible=1/NOCVisible AlrmOwnGrpContact=dre_ops@syniverse.com/AlrmOwnGrpContact Product=DRE/Product" >> /dev/tcp/10.12.7.15/7976
}

filename=/app/logs/server.log
maxsize=100000000
filesize=$(stat -c%s "$filename")
date=$(date '+%Y-%m-%d %H' -d '4 hour ago')
date1=$(date '+%Y-%m-%d %H' -d '5 hour ago')
date2=$(date '+%Y-%m-%d %H' -d '6 hour ago')
date3=$(date '+%Y-%m-%d %H' -d '7 hour ago')
date4=$(date '+%Y-%m-%d %H' -d '8 hour ago')
date5=$(date '+%Y-%m-%d %H' -d '9 hour ago')
date6=$(date '+%Y-%m-%d %H' -d '10 hour ago')
date7=$(date '+%Y-%m-%d %H' -d '11 hour ago')
date8=$(date '+%Y-%m-%d %H' -d '12 hour ago')
date9=$(date '+%Y-%m-%d %H' -d '13 hour ago')

if (( filesize < maxsize )); then
        echo "file size is below 100 MB..Exiting......"
        exit 0
else

if [[ $(grep "Trigger request received" $filename | grep "$date") ]];then
        echo "Trigger requests are receiving";
elif [[ $(grep "Trigger request received" $filename | grep "$date1") ]];then
        echo "Trigger requests are receiving";
elif [[ $(grep "Trigger request received" $filename | grep "$date2") ]];then
        echo "Trigger requests are receiving";
elif [[ $(grep "Trigger request received" $filename | grep "$date3") ]];then
        echo "Trigger requests are receiving";
elif [[ $(grep "Trigger request received" $filename | grep "$date4") ]];then
        echo "Trigger requests are receiving";
elif [[ $(grep "Trigger request received" $filename | grep "$date5") ]];then
        echo "Trigger requests are receiving";
elif [[ $(grep "Trigger request received" $filename | grep "$date6") ]];then
        echo "Trigger requests are receiving";
elif [[ $(grep "Trigger request received" $filename | grep "$date7") ]];then
        echo "Trigger requests are receiving";
elif [[ $(grep "Trigger request received" $filename | grep "$date8") ]];then
        echo "Trigger requests are receiving";
elif [[ $(grep "Trigger request received" $filename | grep "$date9") ]];then
        echo "Trigger requests are receiving";


else
        echo "Trigger requests are not receiving";
        netcool
fi
fi
