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

yum install nginx -y &>>LOGFILE

VALIDATE $? "Installing Nginx" 

systemctl enable nginx  &>>LOGFILE

VALIDATE $? "Enabling Nginx"

systemctl start nginx &>>LOGFILE

VALIDATE $? "Starting Nginx" 


rm -rf /usr/share/nginx/html/* &>>LOGFILE

VALIDATE $? "Removing the Default content in the directory" 

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>LOGFILE

VALIDATE $? "Downloading the Web.zip " 

cd /usr/share/nginx/html &>>LOGFILE
 
VALIDATE $? "Switching to the directory" 

unzip /tmp/web.zip &>>LOGFILE

VALIDATE $? "Unziping web.zip" 

systemctl restart nginx &>>LOGFILE

VALIDATE $? "Restarting Nginx"
