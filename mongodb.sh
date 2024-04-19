#!/bin/bash
DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USER_ID -ne 0 ];
then
    echo -e "$R Error Please execute with sudo privilages $N"
    exit 1
fi 

VALIDATE()
{
    if [ $1 -ne 0 ]; then
        echo -e "$R $2  Failure"
        exit 1
    else
        echo -e "$G $2 Success"
    fi
}

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Setting up the Mongo repo file" 

yum install mongodb-org -y

VALIDATE $? "Installing Mongodb"

systemctl enable mongod

VALIDATE $? "Enabling Mongod"

systemctl start mongod

VALIDATE $? "Starting Mongod"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

VALIDATE $? "Updating the Listening Address"

systemctl restart mongod

VALIDATE $? "Restarting Mongod"

