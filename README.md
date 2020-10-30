# FTP Server

![ftp-logo](ftp.jpg)

Spin up a Dockerised FTP server in AWS to replace old physical server.

## Architecture

- Dedicated VPC
  - single public subnet
  - internet gateway
- single spot EC2 instance
  - brought up with ASG
  - configured with integrated user-data script

## To Run

```bash
# ENSURE you have AWS_PROFILE/AWS_ACCESS_KEY_ID etc exported

# deploy network layer and server
./01-deploy.sh
```

## TODO

- [ ] add ElasticIP 
- [ ] add IAM role 

<!-- - [ ] move cs server password to parameter store
- [ ] create scripts to turn server on/off by incr/decr asg min val -->
