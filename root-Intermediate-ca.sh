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

# cp ../solapurhcareorderer.in/tls-cert.pem tls-cert.pem

pwd 

echo 'Enrolling....'
# ~/go/bin/fabric-ca-client enroll \
# -u https://admin:adminpw@localhost:7054 \
# --caname ca.solapurhcareorderer.in \
# --tls.certfiles ../solapurhcareorderer.in/tls-cert.pem

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

# echo 'Enrolling TLS....'
# ~/go/bin/fabric-ca-client enroll \
# -u https://admin:adminpw@localhost:7054 \
# --caname ca.solapurhcareorderer.in \
# -M tls \
# --csr.hosts 'ca.scsmsr.co.in' \
# --csr.hosts localhost \
# --tls.certfiles ../solapurhcareorderer.in/tls-cert.pem

cp ../solapurhcareorderer.in/tls-cert.pem root-ca-tls-cert.pem
# # cp msp/signcerts/cert.pem ca-cert.pem
# cp msp/cacerts/* msp/ca.crt
# cp msp/signcerts/* msp/server.crt
# cp msp/keystore/* msp/server.key

# cp tls/cacerts/* tls/ca.crt
# cp tls/signcerts/* tls/server.crt
# # cp tls/signcerts/* tls-cert.pem
# cp tls/keystore/* tls/server.key
# cp tls/keystore/* msp/keystore/*

# ~/go/bin/fabric-ca-server init \
# -b admin:adminpw \
# -u https://admin.civilCA:admin.civilCApw@localhost:7054 \
# --tls.certfile tls/server.crt

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

# echo 'Enrolling TLS....'
# ~/go/bin/fabric-ca-client enroll \
# -u https://admin:adminpw@localhost:7054 \
# --caname ca.solapurhcareorderer.in \
# -M tls \
# --csr.hosts ca.ashwinihospital.co.in \
# --csr.hosts localhost \
# --tls.certfiles ../solapurhcareorderer.in/tls-cert.pem

cp ../solapurhcareorderer.in/tls-cert.pem root-ca-tls-cert.pem

# cp msp/cacerts/* msp/ca.crt
# cp msp/signcerts/* msp/server.crt
# cp msp/keystore/* msp/server.key

# cp tls/cacerts/* tls/ca.crt
# cp tls/signcerts/* tls/server.crt
# cp tls/keystore/* tls/server.key
# cp tls/keystore/* msp/keystore/*

# ~/go/bin/fabric-ca-server init \
# -b admin:adminpw \
# -u https://admin.ashwiniCA:admin.ashwiniCApw@localhost:7054 \

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
