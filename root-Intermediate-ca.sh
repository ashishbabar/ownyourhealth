#!/bin/bash

export IMAGE_TAG=latest


if [[ $1 = "stop" ]]; then
cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-solapurhcare-int-ca.yaml stop
docker-compose -f docker-compose-solapurhcare-int-ca.yaml rm -f

cd ../../civil/ca
docker-compose -f docker-compose-civil-int-ca.yaml stop
docker-compose -f docker-compose-civil-int-ca.yaml rm -f

cd ../../ashwini/ca
docker-compose -f docker-compose-ashwini-int-ca.yaml down
# docker-compose -f docker-compose-ca.yaml rm -f

elif [[ $1 = "boot" ]]; then
MODE="up -d"

cd scripts/solapurhcareorderer/ca

docker-compose -f docker-compose-solapurhcare-int-ca.yaml up -d

sleep 5

cd ../../../

cd organizations/fabric-ca

sudo mkdir scsmsr.co.in

sudo chown $USER:$USER scsmsr.co.in -R

cd scsmsr.co.in

export FABRIC_CA_CLIENT_HOME=${PWD}


echo 'Enrolling....'

~/go/bin/fabric-ca-client enroll \
-m admin \
-u https://admin:adminpw@localhost:7054 \
--tls.certfiles ../solapurhcareorderer.in/tls-cert.pem

echo 'Registering....'
~/go/bin/fabric-ca-client register \
--id.name admin.civilCA \
--id.type client \
--id.secret admin.civilCApw \
-m ca.scsmsr.co.in \
--id.attrs '"hf.IntermediateCA=true"' \
-u https://localhost:7054 \
--tls.certfiles ../solapurhcareorderer.in/tls-cert.pem


cp ../solapurhcareorderer.in/tls-cert.pem root-ca-tls-cert.pem

cd ../../../scripts/civil/ca
docker-compose -f docker-compose-civil-int-ca.yaml up -d

cd ../../../organizations/fabric-ca

sudo chown $USER:$USER . -R

sleep 5

cp scsmsr.co.in/ca-chain.pem scsmsr-ca-chain.pem

sudo mkdir ashwinihospital.co.in

sudo chown $USER:$USER ashwinihospital.co.in -R

cd ashwinihospital.co.in

export FABRIC_CA_CLIENT_HOME=${PWD}

echo 'Enrolling....'


~/go/bin/fabric-ca-client enroll \
-m admin \
-u https://admin:adminpw@localhost:7054 \
--tls.certfiles ../solapurhcareorderer.in/tls-cert.pem


echo 'Registering....'
~/go/bin/fabric-ca-client register \
--id.name admin.ashwiniCA \
--id.type client \
--id.secret admin.ashwiniCApw \
--id.attrs '"hf.IntermediateCA=true"' \
-u https://localhost:7054 \
--tls.certfiles ../solapurhcareorderer.in/tls-cert.pem

cp ../solapurhcareorderer.in/tls-cert.pem root-ca-tls-cert.pem

cd ../../../scripts/ashwini/ca
docker-compose -f docker-compose-ashwini-int-ca.yaml up -d

cd ../../../organizations/fabric-ca

sleep 5
cp ashwinihospital.co.in/ca-chain.pem ashwinihospital-ca-chain.pem

elif [[ $1 = "reset" ]]; then
 
cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-solapurhcare-int-ca.yaml stop
docker-compose -f docker-compose-solapurhcare-int-ca.yaml rm -f

cd ../../civil/ca
docker-compose -f docker-compose-civil-int-ca.yaml stop
docker-compose -f docker-compose-civil-int-ca.yaml rm -f

cd ../../ashwini/ca
docker-compose -f docker-compose-ashwini-int-ca.yaml down

cd ../../../

sudo rm organizations/* -rf

pwd 
./root-Intermediate-ca.sh boot

sudo chown $USER:$USER organizations -R

else
cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-solapurhcare-int-ca.yaml up -d

cd ../../civil/ca
docker-compose -f docker-compose-civil-int-ca.yaml up -d

cd ../../ashwini/ca
docker-compose -f docker-compose-ashwini-int-ca.yaml up -d

fi
