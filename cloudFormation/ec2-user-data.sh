#!/bin/bash

readonly logName="/var/log/server-setup.log"

echo "Starting $(date)" | tee -a "${logName}"

echo "Install required tools " | tee -a "${logName}" 
yum install -y \
  docker \
  iptraf-ng \
  htop \
  tmux \
  vim \
  curl

echo "Setting up ssh access"  | tee -a "${logName}"
curl -s https://github.com/jujhars13.keys | tee -a /home/ec2-user/.ssh/authorized_keys

# add ec2 user to the docker group which allows docket to run without being a super-user
usermod -aG docker ec2-user

# running docker daemon as a service
chkconfig docker on
service docker start

echo "Sleeping 2s - wait for docker to start" | tee -a "${logName}"
sleep 2s 

echo "Creating rudemntary web app " | tee -a "${logName}"
mkdir -p /home/ec2-user/webapp
echo "<html><body><h1>Welcome CS peeps</h1><div> We hope you enjoy our cs server</div></body></html>" | tee -a /home/ec2-user/webapp/index.html

echo "Starting nginx web server " | tee -a "${logName}"
docker run -d \
    --restart always \
    -v /home/ec2-user/webapp:/usr/share/nginx/html \
    -p 21:80 \
    nginx

echo "get normal docker entrypoint" | tee -a "${logName}"
# we want to override this from the docker container to customise it
curl https://raw.githubusercontent.com/JimTouz/counter-strike-docker/master/hlds_run.sh -o /custom-entrypoint.sh
sed -i '2 a rm -f /opt/hlds/cstrike/addons/amxmodx/configs/maps.ini' /custom-entrypoint.sh
chmod +x /custom-entrypoint.sh



echo "Finished $(date)" | tee -a "${logName}"


