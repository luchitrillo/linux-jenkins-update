#!/bin/bash

#JenkinsVersionUpdate

echo "# Current Jenkins Version Installed"
JENKINS_CURRENT_VERSION=$(grep version /var/lib/jenkins/config.xml | tail -n1 | cut -d\> -f2 | cut -d\< -f1)
echo $JENKINS_CURRENT_VERSION;echo "";

echo "# Jenkins Stable Version Available"
JENKINS_STABLE_VERSION=$(curl -L --max-redirs 2 https://updates.jenkins.io/stable/latestCore.txt)
echo $JENKINS_STABLE_VERSION;echo "";

echo "# Checking Versions"
if [ $JENKINS_STABLE_VERSION = $JENKINS_CURRENT_VERSION ];then
	echo "# Jenkins current version is the latest stable";echo "";
	exit
else
	echo "# Jenkins current version will be updated to $JENKINS_STABLE_VERSION";echo "";
fi

echo "# Stopping Jenkins Service / Server"
sudo service jenkins stop
echo "# Jenkins Service / Server Stopped";echo "";

echo "# Generating jenkins war files backups"
sudo mv -f /usr/share/jenkins/jenkins.war /usr/share/jenkins/jenkins.war.bkp
find /usr/share/jenkins/ -name jenkins.war.bkp; ls -lhtra /usr/share/jenkins | grep jenkins.war.bkp
sudo mv -f /usr/share/java/jenkins.war /usr/share/java/jenkins.war.bkp
find /usr/share/java/ -name jenkins.war.bkp; ls -lhtra /usr/share/java | grep jenkins.war.bkp
echo "";

echo "# Downloading new Jenkins stable version"
sudo wget -O /usr/share/jenkins/jenkins.war https://get.jenkins.io/war-stable/$JENKINS_STABLE_VERSION/jenkins.war
sudo wget -O /usr/share/java/jenkins.war https://get.jenkins.io/war-stable/$JENKINS_STABLE_VERSION/jenkins.war
echo "";

echo "# Starting Jenkins Service / Server"
sudo service jenkins start
echo "# Jenkins Service / Server Started";echo "";

echo "# Checking New Jenkins Version Installed"
grep version /var/lib/jenkins/config.xml | tail -n1 | cut -d\> -f2 | cut -d\< -f1
echo "";
