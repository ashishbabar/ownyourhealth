export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=${PWD}
export CHANNEL_NAME=general-medicine-channel
export ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/orderer.ashwinihospital.co.in/orderers/orderer.ashwinihospital.co.in/msp/tlscacerts/tlsca.orderer.ashwinihospital.co.in-cert.pem
export ASHWINI_CA=${PWD}/../../organizations/peerOrganizations/ashwinihospital.co.in/peers/ashwinihospital.co.in/tls/ca.crt

export CORE_PEER_LOCALMSPID="AshwiniHospitalMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$ASHWINI_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/../../organizations/peerOrganizations/ashwinihospital.co.in/users/Admin@ashwinihospital.co.in/msp
export CORE_PEER_ADDRESS=localhost:9051
CC_NAME=simpleContract
CC_SRC_PATH=../../chaincode/simple-contract
CC_RUNTIME_LANGUAGE=golang
CC_VERSION=1.0
CC_SEQUENCE=1
CC_INIT_FCN="NA"
CC_END_POLICY="NA"
CC_COLL_CONFIG="NA"
INIT_REQUIRED="--init-required"

cd ../../chaincode/simple-contract

rm go.mod -f
rm go.sum -f
rm simple-contract -f
rm ${CC_NAME}.tar.gz -f 

go mod init gitlab.com/ashishbabar/ownyourhealth/simple-contract
go get -u github.com/hyperledger/fabric-contract-api-go
go mod vendor
go build

echo "Fabric CFG Path is $FABRIC_CFG_PATH"

cd ../../scripts/ashwini

env | grep CORE

echo $CORE_PEER_LOCALMSPID

peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION} >&log.txt
# 
peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt

peer lifecycle chaincode queryinstalled >&log.txt

PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride solapurhcareorderer.in --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} >&log.txt

