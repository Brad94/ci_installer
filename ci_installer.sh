#!/usr/bin/env bash

sudo touch /var/log/ci.log

cd /opt/ || exit
sudo mkdir vagrant_data
cd vagrant_data/ || exit
sudo apt-get update -y

apt-get install -y git
echo "Finished Git." >> /var/log/ci.log

if [ -f "/opt/vagrant_data/jenkins_2.7.4_all.deb" ]
then
	echo "Jenkins file found." >> /var/log/ci.log
else
	echo "Jenkins file not found." >> /var/log/ci.log
 	sudo wget https://pkg.jenkins.io/debian-stable/binary/jenkins_2.7.4_all.deb
fi
sudo dpkg -i jenkins_2.7.4_all.deb
sudo apt-get install -f -y
sudo apt-get install -y jenkins
#sudo su jenkins -s /bin/bash

#echo -ne '\n\n\n' | sudo ssh-keygen
sudo ssh-keygen << EOF



EOF

sudo service jenkins start
echo "Finished Jenkins." >> /var/log/ci.log

if [ -f "/opt/vagrant_data/java.tar.gz" ]
then
	echo "Java File found." >> /var/log/ci.log
else
	echo "Java File not found." >> /var/log/ci.log
  	sudo wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
fi
sudo tar zxvf jdk-8u131-linux-x64.tar.gz
sudo update-alternatives --install /usr/bin/java java /opt/vagrant_data/jdk1.8.0_131/bin/java 100
sudo update-alternatives --install /usr/bin/javac javac /opt/vagrant_data/jdk1.8.0_131/bin/javac 100
java -version
echo "Finished Java." >> /var/log/ci.log

if [ -f "/opt/vagrant_data/maven.tar.gz" ]
then
	echo "Maven File found." >> /var/log/ci.log
else
	echo "Maven File not found." >> /var/log/ci.log
  	sudo wget http://www.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz
fi
sudo tar zxvf apache-maven-3.5.0-bin.tar.gz
sudo update-alternatives --install /usr/bin/mvn mvn /opt/vagrant_data/apache-maven-3.5.0/bin/mvn 100
mvn -version
echo "Finished Maven." >> /var/log/ci.log


if [ -f "/opt/vagrant_data/jira.bin" ]
then
	echo "Jira File found." >> /var/log/ci.log
else
	echo "Jira File not found." >> /var/log/ci.log
	sudo wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.3.6-x64.bin
fi
sudo chmod a+x atlassian-jira-software-7.3.6-x64.bin
./atlassian-jira-software-7.3.6-x64.bin << EOF




2
8081
8006



EOF

echo "Finished Jira." >> /var/log/ci.log

if [ -f "/opt/vagrant_data/latest-unix.tar.gz" ]
then
	echo "Nexus File found." >> /var/log/ci.log
else
	echo "Nexus File not found." >> /var/log/ci.log
	sudo wget http://download.sonatype.com/nexus/3/latest-unix.tar.gz
fi

sudo tar zxvf latest-unix.tar.gz
sudo ./nexus-3.3.1-01/bin/nexus start
echo "Finished Nexus." >> /var/log/ci.log
echo "Everything is done." >> /var/log/ci.log

cat /var/log/ci.log
