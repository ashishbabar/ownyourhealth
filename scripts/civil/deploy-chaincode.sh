export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=${PWD}/../../config
# export FABRIC_CFG_PATH=${PWD}
CHANNEL_NAME=general-medicine-channel
ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/orderer.solapurhcareorderer.in/orderers/orderer.solapurhcareorderer.in/msp/tlscacerts/tlsca.orderer.solapurhcareorderer.in-cert.pem
CIVIL_CA=${PWD}/../../organizations/peerOrganizations/scsmsr.co.in/peers/scsmsr.co.in/tls/ca.crt

export CORE_PEER_LOCALMSPID="SCSMSRMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$CIVIL_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/../../organizations/peerOrganizations/scsmsr.co.in/users/Admin@scsmsr.co.in/msp
export CORE_PEER_ADDRESS=localhost:7051
CC_NAME=simpleContract
CC_SRC_PATH=../../chaincode/simple-contract
CC_RUNTIME_LANGUAGE=golang
CC_VERSION=1.0
CC_SEQUENCE=1
CC_INIT_FCN="NA"
CC_END_POLICY="NA"
CC_COLL_CONFIG="NA"
INIT_REQUIRED="--init-required"
GREEN='\033[0;32m'
NC='\033[0m'

cd ../../chaincode/simple-contract

rm go.mod -f
rm go.sum -f
rm simple-contract -f
rm ${CC_NAME}.tar.gz -f 

go mod init gitlab.com/ashishbabar/ownyourhealth/simple-contract
go get -u github.com/hyperledger/fabric-contract-api-go
go mod vendor
go build

cd ../../scripts/civil
echo ""
echo "-------------------------------------------"
echo "Deploying chaincode for Civil Hospital."
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
