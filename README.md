# msk-eks-connectivity-test

This is to test connectivity from an EKS pot to MSK over TLS.


Steps. 
1. Unzip MSK-EKS_test.zip

2. Make changes to Dockerfile (replace XXXaccess keyXXX and XXXsecret access keyXXX )

3. create a docker image 
   $ docker build -t XXXnameXXX XXXpath-where-zip-is-extractedXXX


4. Create a private repositery.
   https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html

5. Tag and Push the image to the private repo.
   https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html

# NOTE: 
DO NOT PUSH IT TO A PUBLIC REPO. SINCE WE ARE BAKING ACCESS KEY AND SECRET ACCESS KEY INTO THE IMAGE THE CREDENTIALS MIGHT GET LEAKED IF PUBLIC REPO IS USED.

6.  pull the image to run in  as a pod.
    
    > kubectl run --generator run-pod/v1 msktest --image XXXimageXXX --sleep 100000

7. exec into the pod and run the below commands. 
    > kubectl exec msktest -it -- /bin/bash
    
    >/aws# cd /
    
    >/# sh AutomationMSKTLSClient/TLS_STEPS_AUTOMATION.sh Example-Alias XXXARN-OF-PCAXXX changeit changeit 
    
    >/# mkdir /tmp/kafka_2.12-2.2.1/
    
    >/# mv certificate-file client-cert-sign-request kafka.client.keystore.jks kafka.client.truststore.jks new_certificate_file /tmp/kafka_2.12-2.2.1/
    
    >/# kafka_2.12-2.2.1/bin/kafka-topics.sh --create --zookeeper XXXZOOKEPER-CONNECT-STRINGXXX --replication-factor 3 --partitions 1 --topic ExampleTopic

    >/# kafka_2.12-2.2.1/bin/kafka-console-producer.sh --broker-list XXXBOOT-STRAP-BROKER-STRINGXXX --topic ExampleTopic --producer.config kafka_2.12-2.2.1/client.properties