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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? "Downloading Rpm file"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? "Enabling redis 6.2"

dnf install redis -y &>> $LOGFILE

VALIDATE $? "Installing Redis" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOGFILE

VALIDATE $? "Allowing Remote connections" 

systemctl enable redis &>> $LOGFILE

VALIDATE $? "Enabling Redis" 

systemctl start redis &>> $LOGFILE

VALIDATE $? "Starting Redis" 

