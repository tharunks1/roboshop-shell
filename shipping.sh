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

dnf install maven -y  &>> $LOGFILE

VALIDATE $? "Installing Maven"

useradd roboshop &>> $LOGFILE

id roboshop 
if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "User already exist ..$Y Skipping $N"
fi

VALIDATE $? "Creating the user" 

mkdir -p /app &>> $LOGFILE

VALIDATE $? "creating the app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE

VALIDATE $? "Downloading the shipping.zip"

cd /app 

VALIDATE $? "Switching to the app directory"

unzip -o /tmp/shipping.zip &>> $LOGFILE

VALIDATE $? "Unzipping the shipping.zip "


cd /app  $>> $LOGFILE

VALIDATE $? "switching to app directory"

mvn clean package &>> $LOGFILE

VALIDATE $? "compiling and packaging the application"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE

VALIDATE $? "renaming shipping-1.0.jar to shipping.jar"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE

VALIDATE $? "setting up the systemd service"

systemctl daemon-reload  &>> $LOGFILE

VALIDATE $? "Daemon reload"

systemctl enable shipping &>> $LOGFILE

VALIDATE $? "Enabling shipping"

systemctl start shipping &>> $LOGFILE

VALIDATE $? "starting shipping"

dnf install mysql -y &>> $LOGFILE

VALIDATE $? "Installing Mysql" 

mysql -h mysql.chittirobo.shop -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>> $LOGFILE

VALIDATE $? "Loading the schema"








