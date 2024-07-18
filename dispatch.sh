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
dnf install golang -y

VALIDATE $? "Installing Golang"

useradd roboshop &>> $LOGFILE

VALIDATE $? "Adding the user" 

id roboshop &>> $LOGFILE
if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "roboshop user creation "
else
    echo -e "User already exist ..$Y Skipping $N"
fi

VALIDATE $? "creating the user" 

mkdir /app &>> $LOGFILE

VALIDATE $? "Creating app directory" 

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip &>> $LOGFILE


VALIDATE $? "Downloading the Dispatch.zip"

cd /app   &>> $LOGFILE

VALIDATE $? "Switching to app directory"

unzip /tmp/dispatch.zip  &>> $LOGFILE

VALIDATE $? "Unzipping the dispatch.zip"

cd /app    &>> $LOGFILE

VALIDATE $? "Switching to app directory"

go mod init dispatch
go get 
go build

systemctl daemon-reload  &>> $LOGFILE

VALIDATE $? "Daemon-reloading the service"

systemctl enable dispatch   &>> $LOGFILE

VALIDATE $? "Enabling Dispatch"

systemctl start dispatch  &>> $LOGFILE

VALIDATE $? "Starting dispatch"