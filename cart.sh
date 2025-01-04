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

useradd roboshop &>> $LOGFILE

VALIDATE $? "Adding the user" 

id roboshop &>> $LOGFILE
if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "User already exist ..$Y Skipping $N"
fi

mkdir -p /app  

VALIDATE $? "Creating the Directory"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "Downloading the cart data"

cd /app &>> $LOGFILE

VALIDATE $? "Switching to app directory"

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "Unzipping user data"

cd /app &>> $LOGFILE

VALIDATE $? "Switching to app directory"

npm install &>> $LOGFILE

VALIDATE $? "Installing Dependencies"

# use absolute, because user.service exists there
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "Copying cart.service to systemd directory"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "cart Daemon reload"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "Enabling cart"

systemctl start cart &>> $LOGFILE

VALIDATE $? "Starting cart"
