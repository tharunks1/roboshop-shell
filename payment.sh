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
dnf install python36 gcc python3-devel -y &>> $LOGFILE

VALIDATE $? "Installing Python3"


id roboshop
if [ $? -ne 0 ]; then
    useradd roboshop 
    VALIDATE $? "Creating the user" 
else
    echo -e "$G user already exists $N"
fi

VALIDATE $? "creating the roboshop user"

mkdir -p /app  &>> $LOGFILE

VALIDATE $? "Creating the app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip  &>> $LOGFILE

VALIDATE $? "Downloading the payment.zip"

cd /app  &>> $LOGFILE

VALIDATE $? "switching to app directory"

unzip -o /tmp/payment.zip &>> $LOGFILE

VALIDATE $? "unzipping the payment.zip"

cd /app  &>> $LOGFILE

VALIDATE $? "switching to  app directory"

pip3.6 install -r requirements.txt &>> $LOGFILE

VALIDATE $? "INstalling the dependencies" 

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>> $LOGFILE

VALIDATE $? "creating the systemd service" 


systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Performing the daemon-reload"

systemctl enable payment  &>> $LOGFILE

VALIDATE $? "Enabling payment"

systemctl start payment &>> $LOGFILE

VALIDATE $? "Starting Payment"











