#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$0-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "script started executing at $TIMESTAMP" &>>$LOGFILE

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

dnf install nginx -y &>> $LOGFILE

VALIDATE $? "Installing Nginx"

systemctl enable nginx &>> $LOGFILE

VALIDATE $? "Enabling Nginx"

systemctl start nginx &>> $LOGFILE

VALIDATE $? "Starting Nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE

VALIDATE $? "removing the default content "

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE

VALIDATE $? "Downloading the frontend content"

cd /usr/share/nginx/html &>> $LOGFILE

VALIDATE $? "moving nginx html directory"

unzip -o /tmp/web.zip &>> $LOGFILE

VALIDATE $? "Unzipping the web.zip"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE

VALIDATE $? "copying the roboshop conf file to defaultd directory"

systemctl restart nginx &>> $LOGFILE

VALIDATE $? "Restarting Nginx"
