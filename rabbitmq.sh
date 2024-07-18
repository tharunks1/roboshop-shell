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
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "configuring yum repos"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "Configuring yum repos for rabbitmq "

dnf install rabbitmq-server -y  &>> $LOGFILE

VALIDATE $? "Installing Rabbitmq"

systemctl enable rabbitmq-server  &>> $LOGFILE

VALIDATE $? "Enabling Rabbitmq-sever"

systemctl start rabbitmq-server  &>> $LOGFILE

VALIDATE $? "Starting Rabbitmq-server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE

VALIDATE $? "Adding the user and password for roboshop user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> $LOGFILE

VALIDATE $? "settting up the permissions"
