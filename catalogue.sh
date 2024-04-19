#!/bin/bash
LOGDIR=/home/centos/Shell_script
SCRIPT_NAME=$0
DATE=$(date +%F)
LOGFILE=$LOGDIR/$SCRIPT_NAME-$DATE.log
USER_ID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USER_ID -ne 0 ];
then
	echo -e "$R Error , Please execute with sudo privileages $N"
	exit 1
fi
VALIDATE()
{
if [ $1 -ne 0 ];
then 
	echo -e "$2....$R Failure $N"
	exit 1
else
	echo -3 "$2....$G Success $N"
fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Setting Up script" &>>$LOGFILE

yum install nodejs -y

VALIDATE $? "Installing Node js" &>>$LOGFILE

useradd roboshop

VALIDATE $? "Adding the apk user" &>>$LOGFILE 

mkdir /app

VALIDATE $? "Creating Directory" &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

VALIDATE $? "Downloading Catalogue Zip" &>>$LOGFILE

cd /app 

VALIDATE $? "Switching to app directory" &>>$LOGFILE

unzip /tmp/catalogue.zip

VALIDATE $? "Unzipping Catalogue.zip" &>>$LOGFILE

cd /app

VALIDATE $? "Switching to App directory" &>>$LOGFILE

npm install 

VALIDATE $? "Installing NPM dependencies" &>>$LOGFILE

cp /home/centos/Shell-script/catalogue.service /etc/systemd/system/catalogue.service

VALIDATE $? "Copying the catalogue.service" &>>$LOGFILE

systemctl daemon-reload

VALIDATE $? "Performing the Daemon-reload" &>>$LOGFILE

systemctl enable catalogue

VALIDATE $? "Enabling the catalogue" &>>$LOGFILE

systemctl start catalogue

VALIDATE $? "Starting the catalogue" &>>$LOGFILE

cp /home/centos/Shell-script/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "Copying mongo.repo" &>>$LOGFILE

yum install mongodb-org-shell -y

VALIDATE $? "Installing Mongodb shell" &>>$LOGFILE

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js

VALIDATE $? "Loading the App-Schema into DB" &>>$LOGFILE
