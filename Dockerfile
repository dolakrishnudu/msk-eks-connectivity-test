FROM ubuntu:18.04
ENV AWS_DEFAULT_REGION="us-east-1"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install curl -y \
    && apt-get install vim -y \
    && apt-get install git -y \
    && apt-get install netcat -y \
    && apt-get install -y openjdk-8-jdk  \
    && apt-get install -y ant \
    && apt-get install ca-certificates-java \
    && update-ca-certificates -f \
    && apt-get install -y --no-install-recommends python \
    && apt-get install -y  python3-pip \
    && apt-get install -y  awscli \
    && pip3 install awscli --upgrade --user  \
    && apt-get install libssl-dev -y \
    && apt-get install -y  openjdk-8-jdk \
    && apt-get install -y -qq groff \
    && aws --profile default configure set aws_access_key_id <access key> \
    && aws --profile default configure set aws_secret_access_key <secret access key> \
    && aws --profile default configure set aws_default_region us-east-1 \
    && aws --version \  
    && aws help

WORKDIR /aws
ADD  kafka_2.12-2.2.1 /kafka_2.12-2.2.1
ADD AutomationMSKTLSClient /AutomationMSKTLSClient

