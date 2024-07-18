#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$0-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "script started executing at $TIMESTAMP" &>> $LOGFILE

#checking whether the user has root access or not
#------------------------------------------------
if [ $ID -ne 0 ]; then
    echo -e "$R you are not root user.Please Execute with root access $N"
    exit 1
else
    echo -e "$G you are root user $N"
fi

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2.........$R FAILED $N"
        exit 1
    else
        echo -e "$2.........$G SUCCESS $N"
    fi
}
#

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling default NodeJS"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling NodeJs 18" 

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing NodeJS"


id roboshop
if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "User already exist ..$Y Skipping $N"
fi

mkdir -p /app  

VALIDATE $? "Creating the Directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "Downloading Catalogue"

cd /app &>> $LOGFILE

VALIDATE $? "Switching to app directory"

unzip -o /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "Unzipping Catalogue"

cd /app &>> $LOGFILE

VALIDATE $? "Switching to app directory"

npm install &>> $LOGFILE

VALIDATE $? "Installing Dependencies"

# use absolute, because catalogue.service exists there
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "Copying Catalogue.service to systemd directory"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Catalogue Daemon reload"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enabling Catalogue"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Starting Catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing MongoDB client"

mongo --host mongodb.chittirobo.shop </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loading catalouge data into MongoDB"
