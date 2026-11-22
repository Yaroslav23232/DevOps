#!/bin/bash
echo "Updating system..."
sudo apt-get update -y

echo "Installing Java 17 and Maven..."
sudo apt-get install -y openjdk-17-jdk maven

echo "Building and running Spring PetClinic..."
cd /vagrant
./mvnw package -DskipTests
nohup java -jar target/*.jar > app.log 2>&1 &
echo "PetClinic started successfully on port 8080!"
