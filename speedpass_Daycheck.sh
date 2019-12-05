#!/bin/bash
#Written by Charan Billinty-Dre Ops
#To check Total speed pass purchases by day

ALERTGROUP="DRE BELL"
ALERTKEY1="speed pass purchase policy day"
ALERTKEY2="speed pass purchases service day"
ALERTKEY3="speed pass purchases webservice day"

SEVERITY=4

netcool1 ()
{
echo "NC_RICH_ALARM Node=${HOSTNAME}/Node AlertGroup=${ALERTGROUP}/AlertGroup AlertKey=${ALERTKEY1}/AlertKey Type=1/Type Severity=${SEVERITY}/Severity Summary=$1/Summary NOCVisible=1/NOCVisible AlrmOwnGrpContact=dre_ops@syniverse.com/AlrmOwnGrpContact Product=DRE/Product" >> /dev/tcp/10.12.7.15/7976
}

netcool2 ()
{
echo "NC_RICH_ALARM Node=${HOSTNAME}/Node AlertGroup=${ALERTGROUP}/AlertGroup AlertKey=${ALERTKEY2}/AlertKey Type=1/Type Severity=${SEVERITY}/Severity Summary=$1/Summary NOCVisible=1/NOCVisible AlrmOwnGrpContact=dre_ops@syniverse.com/AlrmOwnGrpContact Product=DRE/Product" >> /dev/tcp/10.12.7.15/7976
}

netcool3 ()
{
echo "NC_RICH_ALARM Node=${HOSTNAME}/Node AlertGroup=${ALERTGROUP}/AlertGroup AlertKey=${ALERTKEY3}/AlertKey Type=1/Type Severity=${SEVERITY}/Severity Summary=$1/Summary NOCVisible=1/NOCVisible AlrmOwnGrpContact=dre_ops@syniverse.com/AlrmOwnGrpContact Product=DRE/Product" >> /dev/tcp/10.12.7.15/7976
}


date1=` date "+%Y%m%d" -d '24 hours ago' `
filename=/app/logs/backup/`date +"%b%Y"`/server.log.$date1*
date2=` date '+%Y-%m-%d' -d '24 hour ago' `
filename1=/app/logs/server.lo
count1=10
count2=20
Num=0

###########################################################################PolicyException###############################################################################
policycount=` zgrep -E "$date2.*PolicyException occured while sending SMS : MessageId" $filename|wc -l `
        echo $policycount;

policycount1=` awk -v date="$(date '+%Y-%m-%d' -d '24 hour ago')" '$0~date && /PolicyException occured while sending SMS : MessageId/' $filename1* |wc -l `
        echo $policycount1;

pcount=` expr $policycount + $policycount1 `
        echo $pcount

if ((pcount >Num && pcount<= count1));
        then
                echo "notify Gord";
                Alert_Text1="PolicyException occured while sending SMS is less than the threshold in a day(count is $pcount). Notify DRE Ops: Ref-http://dremachine/index.php/Total_speed_pass_purchases_by_day_-_Procedure_to_report"
                netcool1 "${Alert_Text1}"
        output="`sqlplus64 -s cdr/cdr123@dal-racp008:2032/bell.dre.cdr <<EOF

set colsep ,
set heading off
set linesize 3000
set pagesize 20
set headsep off
set trimspool on

spool presult.csv

select IMSI, MSISDN, START_DATE_TIME as NOTIFICATION_TIME, NOTIFICATION_TEXT_EN from MC_SMS_NOTIFICATION_BELL where start_date_time > sysdate - 2 and trunc(start_date_time) = trunc(sysdate - 1) and NOTIFICATION_STATUS=5
/
spool off
exit;
EOF`"
echo "$output"
sed -i '1s/^/IMSI ,MSISDN ,NOTIFICATION_TIME ,NOTIFICATION_TEXT_EN.  /' presult.csv ;
sleep 20;
echo "Hello Gord,

Please find the attached PolicyException error occurred while sending SMS for the date `date '+%Y-%m-%d' -d '24 hour ago'`" | mailx -s "Speed pass purchase exceptions: `date '+%Y-%m-%d' -d '24 hour ago'`" -a /home/dreadmin/scripts/presult.csv "raju.john@syniverse.com" "charan.billinty@syniverse.com" ;


else
                echo "No issue";
fi



###################################################################ServiceException###################################################################################################
servicecount=` zgrep -E "$date2.*ServiceException occured while sending SMS : MessageId" $filename |wc -l`
        echo $servicecount;

servicecount1=` awk -v date="$(date '+%Y-%m-%d' -d '24 hour ago')" '$0~date && /ServiceException occured while sending SMS : MessageId/' $filename1* |wc -l `
        echo $servicecount1;

scount=` expr $servicecount + $servicecount1 `
        echo $scount

if ((scount >Num && scount<= count1));
        then
                echo "notify Gord";
                Alert_Text2="ServiceException occured while sending SMS is less than the threshold in a day(count is $scount). Notify DRE Ops: Ref-http://dremachine/index.php/Total_speed_pass_purchases_by_day_-_Procedure_to_report"
                netcool2 "${Alert_Text2}"
else
        echo "No issue";
fi


##############################################################################InvokeSmsSender##########################################################################################
invokecount=` zgrep -E "$date2.*invokeSmsSenderService() : Exception Occured WebServiceException" $filename |wc -l`
        echo $invokecount;

invokecount1=` awk -v date="$(date '+%Y-%m-%d' -d '24 hour ago')" '$0~date && /invokeSmsSenderService() : Exception Occured WebServiceException/' $filename1* |wc -l `
        echo $invokecount1;

icount=` expr $invokecount + $invokecount1 `
        echo $icount

if ((icount >Num && icount<= count1));
        then
                echo "notify Gord";
                Alert_Text3="WebServiceException occured while sending SMS is less than the threshold in a day(count is $scount). Notify DRE Ops: Ref-http://dremachine/index.php/Total_speed_pass_purchases_by_day_-_Procedure_to_report"
                netcool3 "{Alert_Text3}"
else
        echo "No issue";
fi

rm -rf /home/dreadmin/scripts/presult.csv;
