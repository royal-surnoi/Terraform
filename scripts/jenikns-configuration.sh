#!/bin/bash

###############################################
# Author: ROYAL REDDY
# Version: V3
# Purpose: installation of
    #   utils,
    #   git,
    #   docker,docker-compose,
    #   kubectl,
    #   Helm,
    #   terraform,
    #   java 21
################################################


ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

ARCH=amd64
PLATFORM=$(uname -s)_$ARCH


TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

sudo yum install -y yum-utils
VALIDATE $? "Installed yum utils"

# git
sudo yum install -y git
VALIDATE $? "Installed yum git"

# docker
sudo yum install -y docker
VALIDATE $? "Installed docker components"

sudo service docker start
VALIDATE $? "Started docker"

sudo systemctl enable docker
VALIDATE $? "Enabled docker"

# docker compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
VALIDATE $? "Enabled docker"

sudo chmod +x /usr/local/bin/docker-compose
VALIDATE $? "Enabled docker"

sudo usermod -a -G docker ec2-user
VALIDATE $? "added ec2-user user to docker group"
echo -e "$R Logout and login again $N"

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
VALIDATE $? "Kubectl installation"

# # eksctl
# curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
# tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
# sudo mv /tmp/eksctl /usr/local/bin
# VALIDATE $? "eksctl installation"

# helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
# VALIDATE $? "helm installation" 

# # k9s
# curl -sS https://webinstall.dev/k9s | bash
# VALIDATE $? "k9s installation"

# # aws-ebs-csi-driver
# helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
# helm repo update

# helm upgrade --install aws-ebs-csi-driver \
#     --namespace kube-system \
#     aws-ebs-csi-driver/aws-ebs-csi-driver
# VALIDATE $? "aws-ebs-csi-driver installation"

# kubens
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
VALIDATE $? "kubens installation"


# # metrics server 
# kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
# VALIDATE $? "metrics installation"

# terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
VALIDATE $? "Installed yum git"


# install java
sudo yum list installed java &>> $LOG_FILE

if [ $? -ne 0 ]
then
    yum install java-21-amazon-corretto-devel -y  &>> $LOG_FILE
    VALIDATE $? "Java-21 Installed and started the service"
else
    echo -e "Java-21 already Installed $Y SKIPPING $N"
fi

# add jenkins default to yum package repo
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo &>> $LOG_FILE
VALIDATE $? "add jenkins default to yum package repo"

# Import a key file from Jenkins-CI to enable installation from the package
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key &>> $LOG_FILE
VALIDATE $? "Import a key file from Jenkins-CI to enable installation from the package"

# Install Jenkins check before install 
yum list installed Jenkins &>> $LOG_FILE
if [ $? -ne 0 ]
then
    yum install jenkins -y  &>> $LOG_FILE
    systemctl enable jenkins &>> $LOG_FILE
    systemctl start jenkins &>> $LOG_FILE
    VALIDATE $? "Jenkins Installed and started the service"
else
    echo -e "jenkin already Installed $Y SKIPPING $N"
fi


yum list installed nodejs &>> $LOG_FILE
# install node
if [ $? -ne 0 ]
then
    # remove default nodejs in yum package repo
    curl -fsSL https://rpm.nodesource.com/setup_20.x |  bash - &>> $LOG_FILE
    yum install nodejs -y &>> $LOG_FILE
    VALIDATE $? "nodejs Installed and started the service"
else
    echo -e "nodejs already Installed $Y SKIPPING $N"
fi

# display the versions 
echo "node version $(node --version)"
echo "npm version $(npm --version) "


ng version &>> $LOG_FILE
# install angular
if [ $? -ne 0 ]
then
    # remove default angular in yum package repo
    npm install -g @angular/cli@latest &>> $LOG_FILE
    VALIDATE $? "angular Installed and started the service"
else
    echo -e "angular already Installed  $Y SKIPPING $N"
fi

# display the versions 
echo "npm version $(ng version)"

# Change directory to app
cd /opt

# Download maven binary
wget https://archive.apache.org/dist/maven/maven-3/3.9.8/binaries/apache-maven-3.9.8-bin.tar.gz &>> $LOG_FILE

# efile
tar xvf apache-maven-3.9.8-bin.tar.gz &>> $LOG_FILE

mv apache-maven-3.9.8 maven
rm -rf apache-maven-3.9.8
# Path to the Maven bin directory
maven_bin_dir="/opt/maven/bin"

# Append the Maven bin directory to the PATH variable
# unset PATH

if [[ ! "$PATH" =~ "/opt/maven/bin" ]]; then
    export PATH="$PATH:$maven_bin_dir"
fi


echo "Maven bin directory added to PATH: $PATH"

# previous directory
cd -

# Display maven version
mvn --version