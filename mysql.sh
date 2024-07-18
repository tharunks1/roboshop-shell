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

dnf module disable mysql -y &>> $LOGFILE

VALIDATE $? "Disabling Mysql Module" 

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE

VALIDATE $? "Copying mysql repo to yum.repos.d" 

dnf install mysql-community-server -y &>> $LOGFILE

VALIDATE $? "Installing Mysql community server" 

systemctl enable mysqld &>> $LOGFILE

VALIDATE $? "Enabling Mysqld" 

systemctl start mysqld &>> $LOGFILE

VALIDATE $? "Starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

VALIDATE $? "Setting the password for mysql"

mysql -uroot -pRoboShop@1 

VALIDATE $? "Mysql root password"

