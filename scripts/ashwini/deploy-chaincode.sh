#!/bin/bash
export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=${PWD}/../../config
# export FABRIC_CFG_PATH=${PWD}
export CHANNEL_NAME=general-medicine-channel
# export ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/orderer.ashwinihospital.co.in/orderers/orderer.ashwinihospital.co.in/msp/tlscacerts/tlsca.orderer.ashwinihospital.co.in-cert.pem
ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/orderer.solapurhcareorderer.in/orderers/orderer.solapurhcareorderer.in/msp/tlscacerts/tlsca.orderer.solapurhcareorderer.in-cert.pem

export ASHWINI_CA=${PWD}/../../organizations/peerOrganizations/ashwinihospital.co.in/peers/opd.ashwinihospital.co.in/tls/ca.crt

export CORE_PEER_LOCALMSPID="AshwiniHospitalMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$ASHWINI_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/../../organizations/peerOrganizations/ashwinihospital.co.in/users/Admin@ashwinihospital.co.in/msp
export CORE_PEER_ADDRESS=localhost:9051
# CC_NAME=simpleContract
# CC_SRC_PATH=../../chaincode/simple-contract
CC_NAME=${1}
CC_DIR=${2}
CC_SRC_PATH=../../chaincode/${CC_DIR}
CC_RUNTIME_LANGUAGE=golang
CC_VERSION=1.0
CC_SEQUENCE=1
CC_INIT_FCN=""
# CC_END_POLICY="NA"
# # CC_END_POLICY="OR ('AshwiniHospitalMSP.peer','SCSMSRMSP.peer')"
# CC_COLL_CONFIG="NA"
INIT_REQUIRED="--init-required"
GREEN='\033[0;32m'
NC='\033[0m'

cd ../../chaincode/${CC_DIR}

rm go.mod -f
rm go.sum -f
rm ${CC_DIR} -f
rm ${CC_NAME}.tar.gz -f 

go mod init gitlab.com/ashishbabar/ownyourhealth/${CC_DIR}
go get -u github.com/hyperledger/fabric-contract-api-go
go mod vendor
go build


cd ../../scripts/ashwini
echo ""
echo "-------------------------------------------"
echo "Deploying chaincode for Ashwini Hospital."
echo "-------------------------------------------"

printf "Packaging chaincode to ${CC_SRC_PATH} ... "
peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION} >&log/package-log.txt
echo -e "${GREEN}done${NC}"

printf "Installing chaincode ${CC_NAME}.tar.gz ... "
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log/install-log.txt
echo -e "${GREEN}done${NC}"

printf "Querying  chaincode ${CC_NAME} ... "
peer lifecycle chaincode queryinstalled >&log/query-log.txt
echo -e "${GREEN}done${NC}"

PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log/query-log.txt)

printf "Approving chaincode for Package ID $PACKAGE_ID ... "
sleep 5

peer lifecycle chaincode approveformyorg \
-o localhost:7050 \
--ordererTLSHostnameOverride orderer.solapurhcareorderer.in \
--tls --cafile $ORDERER_CA \
--channelID $CHANNEL_NAME \
--name ${CC_NAME} \
--version ${CC_VERSION} \
--package-id ${PACKAGE_ID} \
--sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} >&log/approve-log.txt
echo -e "${GREEN}done${NC}"

