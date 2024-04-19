#!/bin/bash
LOGSDIR=/tmp
DATE=$(date +%F)
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log
USER_ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USER_ID -ne 0 ];
then
    echo -e "$R ERROR Please Execute with Sudo Privilages"
    exit 1
fi

VALIDATE()
{
    if [ $1 -ne 0 ];
    then
        echo -e "$2 $R Installation Failure $N"
    else
        echo -e "$2 $G Installation Success $N"
    fi
}

yum install nginx -y

VALIDATE $? "Installing Nginx" &>>LOGFILE

systemctl enable nginx

VALIDATE $? "Enabling Nginx" &>>LOGFILE

systemctl start nginx

VALIDATE $? "Starting Nginx" &>>LOGFILE


rm -rf /usr/share/nginx/html/*

VALIDATE $? "Removing the Default content in the directory" &>>LOGFILE

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

VALIDATE $? "Downloading the Web.zip " &>>LOGFILE

cd /usr/share/nginx/html

VALIDATE $? "Switching to the directory" &>>LOGFILE

unzip /tmp/web.zip

VALIDATE $? "Unziping web.zip" &>>LOGFILE

systemctl restart nginx 

VALIDATE $? "Restarting Nginx" &>>LOGFILE
