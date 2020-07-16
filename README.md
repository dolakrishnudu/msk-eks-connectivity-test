# msk-eks-connectivity-test

This is to test connectivity from an EKS pot to MSK over TLS.


Steps. 
1. Unzip MSK-EKS_test.zip

2. Make changes to Dockerfile (replace <access key> and <secret access key>)

3. create a docker image 
   $ docker build -t <name> <path-where-zip-is-extracted>


3. Create a private repositery.
   https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html

4. Tag and Push the image to the private repo.
   https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html

# NOTE: 
DO NOT PUSH IT TO A PUBLIC REPO. SINCE WE ARE BAKING ACCESS KEY AND SECRET ACCESS KEY INTO THE IMAGE THE CREDENTIALS MIGHT GET LEAKED IF PUBLIC REPO IS USED.

5.  pull the image to run in  as a pod.
    
    & kubectl run --generator run-pod/v1 msktest --image <image> --sleep 100000

6. exec into the pod and run the below commands. 
    $ kubectl exec msktest -it -- /bin/bash
    /aws# cd /
    /# sh AutomationMSKTLSClient/TLS_STEPS_AUTOMATION.sh Example-Alias <ARN-OF-PCA> changeit changeit 
    /# mkdir /tmp/kafka_2.12-2.2.1/
    /# mv certificate-file client-cert-sign-request kafka.client.keystore.jks kafka.client.truststore.jks new_certificate_file /tmp/kafka_2.12-2.2.1/
    /# kafka_2.12-2.2.1/bin/kafka-topics.sh --create --zookeeper <ZOOKEPER-CONNECT-STRING> --replication-factor 3 --partitions 1 --topic ExampleTopic
    
    /# kafka_2.12-2.2.1/bin/kafka-console-producer.sh --broker-list <BOOT-STRAP-BROKER-STRING> --topic ExampleTopic --producer.config kafka_2.12-2.2.1/client.properties