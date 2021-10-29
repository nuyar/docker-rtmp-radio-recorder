#!/bin/bash

# set timezone
ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

# clear crontab file
if [[ -e "/etc/cron.d/record-cron" ]]; then
    rm /etc/cron.d/record-cron
    touch /etc/cron.d/record-cron
fi


# make default schedule file
if [[ ! -e "/data/schedule.txt" ]]; then
    mkdir /data
    touch /data/schedule.txt
    echo "#{START_HOUR} {START_MINUTE} {RTMP_ADDRESS} {RECORD_MINUTE} {PROGRAM_NAME} {DIRECTORY}" > /data/schedule.txt
fi

# read schedule file and add schedules to cronjob
schedulecount=0
while  read -r line; do
    while IFS=' ' read -ra vals; do
        if (("${#vals[@]}" != "6")); then
            echo "each line should have 6 args : ${line}"
        else
            schedulecount=$(($schedulecount + 1))
            croncmd="/record.sh ${vals[2]} ${vals[3]} ${vals[4]} ${vals[5]} >> /data/cron.log 2>&1"
            cronjob="${vals[1]} ${vals[0]} * * * $croncmd"
            echo "${cronjob}" >> /etc/cron.d/record-cron
            echo "(job ${schedulecount}) ${cronjob}"
        fi
    done < <(echo $line)
done < <(grep -o '^[^#]*' /data/schedule.txt)

# clear log file
if [[ -e "/data/cron.log" ]]; then
    rm /data/cron.log
    touch /data/cron.log
fi

# start cron
if (("$schedulecount" >= 1)); then
    chmod 0644 /etc/cron.d/record-cron
    crontab /etc/cron.d/record-cron
    crontab -l
    touch /data/cron.log
    echo "waiting for schedules..."
    cron && tail -f /data/cron.log
else
    echo "there is no schedule."
fi