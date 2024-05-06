#!/bin/bash
DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
if [ $USERID -ne 0 ];
then
    echo -e "Please execute with sudo privilages"
    exit 1
fi
VALIDATE() 
{
    if [ $1 -ne 0 ];
    then
        echo -e "$2.....$R failure $N"
        exit 1
    else
        echo -e "$2.....$G Success $N"
        fi
}
yum install nginx -y

VALIDATE $? "Installing nginx" &>>$LOGFILE

systemctl enable nginx

VALIDATE $? "Enabling Nginx" &>>$LOGFILE

systemctl start nginx

VALIDATE $? "Starting Nginx" &>>$LOGFILE

rm -rf /usr/share/nginx/html/*

VALIDATE $? "Removing default content" &>>$LOGFILE

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

VALIDATE $? "Downloading the Artifcat"

cd /usr/share/nginx/html

VALIDATE $? "Switching to the html direcotory"

unzip /tmp/web.zip 

VALIDATE $? "Unzipping the zip file"

cp "/home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf"

VALIDATE $? "Copying the robo.conf to etc directory"

systemctl restart nginx 

VALIDATE $? "Restarting Nginx"
