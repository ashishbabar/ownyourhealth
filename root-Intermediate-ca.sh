export IMAGE_TAG=latest


if [[ $1 = "stop" ]]; then
cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-ca.yaml stop
docker-compose -f docker-compose-ca.yaml rm -f

cd ../../civil/ca
docker-compose -f docker-compose-ca.yaml stop
docker-compose -f docker-compose-ca.yaml rm -f

cd ../../ashwini/ca
docker-compose -f docker-compose-ca.yaml down
# docker-compose -f docker-compose-ca.yaml rm -f

elif [[ $1 = "boot" ]]; then
MODE="up -d"

cd scripts/solapurhcareorderer/ca

docker-compose -f docker-compose-ca.yaml up -d

sleep 10

cd ../../../

cd organizations/fabric-ca

sudo mkdir scsmsr.co.in

sudo chown $USER:$USER scsmsr.co.in -R

cd scsmsr.co.in

export FABRIC_CA_CLIENT_HOME=${PWD}

# cp ../solapurhcareorderer.in/tls-cert.pem tls-cert.pem

pwd 

~/go/bin/fabric-ca-client enroll \
-u https://admin:adminpw@localhost:7054 \
--caname ca.solapurhcareorderer.in \
--tls.certfiles ../solapurhcareorderer.in/tls-cert.pem

~/go/bin/fabric-ca-client register \
--id.name admin.civilCA \
--id.type client \
--id.secret admin.civilCApw \
--id.attrs '"hf.IntermediateCA=true"' \
-u https://localhost:7054 \
--tls.certfiles ../solapurhcareorderer.in/tls-cert.pem

~/go/bin/fabric-ca-client enroll \
-u https://admin:adminpw@localhost:7054 \
--caname ca.solapurhcareorderer.in \
-M tls \
--csr.hosts ca.scsmsr.co.in \
--csr.hosts localhost \
--tls.certfiles ../solapurhcareorderer.in/tls-cert.pem

cp msp/signcerts/cert.pem ca-cert.pem
cp msp/cacerts/* msp/ca.crt
cp msp/signcerts/* msp/server.crt
cp msp/keystore/* msp/server.key

cp tls/cacerts/* tls/ca.crt
cp tls/signcerts/* tls/server.crt
cp tls/signcerts/* tls-cert.pem
cp tls/keystore/* tls/server.key
cp tls/keystore/* msp/keystore/*

# ~/go/bin/fabric-ca-server init \
# -b admin:adminpw \
# -u https://admin.civilCA:admin.civilCApw@localhost:7054 \
# --tls.certfile ../solapurhcareorderer.in/tls-cert.pem

cd ../../../scripts/civil/ca
docker-compose -f docker-compose-ca.yaml up -d

cd ../../../organizations/fabric-ca

sudo mkdir ashwinihospital.co.in

sudo chown $USER:$USER ashwinihospital.co.in -R

cd ashwinihospital.co.in

export FABRIC_CA_CLIENT_HOME=${PWD}

# cp ../solapurhcareorderer.in/tls-cert.pem tls-cert.pem


~/go/bin/fabric-ca-client enroll \
-u https://admin:adminpw@localhost:7054 \
--caname ca.solapurhcareorderer.in \
--tls.certfiles ../solapurhcareorderer.in/tls-cert.pem

~/go/bin/fabric-ca-client register \
--id.name admin.ashwiniCA \
--id.type client \
--id.secret admin.ashwinipw \
--id.attrs '"hf.IntermediateCA=true"' \
-u https://localhost:7054 \
--tls.certfiles ../solapurhcareorderer.in/tls-cert.pem

~/go/bin/fabric-ca-client enroll \
-u https://admin:adminpw@localhost:7054 \
--caname ca.solapurhcareorderer.in \
-M tls \
--csr.hosts ca.ashwinihospital.co.in \
--csr.hosts localhost \
--tls.certfiles ../solapurhcareorderer.in/tls-cert.pem

cp msp/signcerts/cert.pem ca-cert.pem
cp msp/cacerts/* msp/ca.crt
cp msp/signcerts/* msp/server.crt
cp msp/keystore/* msp/server.key

cp tls/cacerts/* tls/ca.crt
cp tls/signcerts/* tls/server.crt
cp tls/signcerts/* tls-cert.pem
cp tls/keystore/* tls/server.key
cp tls/keystore/* msp/keystore/*

cd ../../../scripts/ashwini/ca
docker-compose -f docker-compose-ca.yaml up -d

elif [[ $1 = "reset" ]]; then
 
cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-ca.yaml stop
docker-compose -f docker-compose-ca.yaml rm -f

cd ../../civil/ca
docker-compose -f docker-compose-ca.yaml stop
docker-compose -f docker-compose-ca.yaml rm -f

cd ../../ashwini/ca
docker-compose -f docker-compose-ca.yaml down
# docker-compose -f docker-compose-ca.yaml rm -f

cd ../../../

sudo rm organizations/* -rf

pwd 
./root-Intermediate-ca.sh boot

sudo chown $USER:$USER organizations -R

else
cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-ca.yaml up -d

cd ../../civil/ca
docker-compose -f docker-compose-ca.yaml up -d

cd ../../ashwini/ca
docker-compose -f docker-compose-ca.yaml up -d

fi
