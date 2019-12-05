
#!/bin/bash
#Written by Raju John-DRE Ops
#To track speed pass purchase exceptions

ALERTGROUP="DRE BELL"
ALERTKEY1="speed pass purchase policy hour"
ALERTKEY2="speed pass purchase service hour"
ALERTKEY3="speed pass purchase webservice hour"

ALERT_TEXT1="PolicyException occured while sending SMS is greater than threshold in an hour.Notify DRE-Ops.Ref:http://dremachine/index.php/Total_speed_pass_purchases_by_day_-_Procedure_to_report"
ALERT_TEXT2="ServiceException occured while sending SMS is greater than threshold in an hour.Notify DRE-Ops.Ref:http://dremachine/index.php/Total_speed_pass_purchases_by_day_-_Procedure_to_report"
ALERT_TEXT3="WebServiceException is greater than threshold in an hour.Notify DRE-Ops.Ref:http://dremachine/index.php/Total_speed_pass_purchases_by_day_-_Procedure_to_report"

SEVERITY=5

netcool1 ()
{
echo "NC_RICH_ALARM Node=${HOSTNAME}/Node AlertGroup=${ALERTGROUP}/AlertGroup AlertKey=${ALERTKEY1}/AlertKey Type=1/Type Severity=${SEVERITY}/Severity Summary=${ALERT_TEXT1}/Summary NOCVisible=1/NOCVisible AlrmOwnGrpContact=dre_ops@syniverse.com/AlrmOwnGrpContact Product=DRE/Product" >> /dev/tcp/10.12.7.15/7976
}

netcool2 ()
{
echo "NC_RICH_ALARM Node=${HOSTNAME}/Node AlertGroup=${ALERTGROUP}/AlertGroup AlertKey=${ALERTKEY2}/AlertKey Type=1/Type Severity=${SEVERITY}/Severity Summary=${ALERT_TEXT2}/Summary NOCVisible=1/NOCVisible AlrmOwnGrpContact=dre_ops@syniverse.com/AlrmOwnGrpContact Product=DRE/Product" >> /dev/tcp/10.12.7.15/7976
}

netcool3 ()
{
echo "NC_RICH_ALARM Node=${HOSTNAME}/Node AlertGroup=${ALERTGROUP}/AlertGroup AlertKey=${ALERTKEY3}/AlertKey Type=1/Type Severity=${SEVERITY}/Severity Summary=${ALERT_TEXT3}/Summary NOCVisible=1/NOCVisible AlrmOwnGrpContact=dre_ops@syniverse.com/AlrmOwnGrpContact Product=DRE/Product" >> /dev/tcp/10.12.7.15/7976
}



filename=/app/logs/server.lo
count1=10
count2=20



policycount=` awk -v date="$(date '+%Y-%m-%d %H' -d '6 hour ago')" '$0~date && /PolicyException occured while sending SMS : MessageId :/' $filename* | wc -l `
echo $policycount
if ((policycount > count1 ));then
        echo "Policy exception is above 10 for past hour";
        netcool1
else
        echo "Policy exception not found";

fi

servicecount=` awk -v date="$(date '+%Y-%m-%d %H' -d '6 hour ago')" '$0~date && /ServiceException occured while sending SMS : MessageId :/' $filename* | wc -l `
echo $servicecount
if ((servicecount > count1 ));then
        echo "Service exception is above 10 for past hour";
        netcool2
else
        echo "Service exception not found";

fi

invokecount=` awk -v date="$(date '+%Y-%m-%d %H' -d '6 hour ago')" '$0~date && /invokeSmsSenderService() : Exception Occured WebServiceException/' $filename* | wc -l `
echo $invokecount
if ((invokecount > count2 ));then
        echo "Webservice exception is above 20 past hour";
        netcool3
else
        echo "Webservice exception not found";

fi
