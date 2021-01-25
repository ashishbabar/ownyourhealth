#!/bin/bash
export CORE_PEER_TLS_ENABLED=true
# export FABRIC_CFG_PATH=${PWD}
export FABRIC_CFG_PATH=${PWD}/../../config

export CHANNEL_NAME=general-medicine-channel
export ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/orderer.solapurhcareorderer.in/orderers/orderer.solapurhcareorderer.in/msp/tlscacerts/tlsca.orderer.solapurhcareorderer.in-cert.pem
export ASHWINI_CA=${PWD}/../../organizations/peerOrganizations/ashwinihospital.co.in/peers/ashwinihospital.co.in/tls/ca.crt
CIVIL_CA=${PWD}/../../organizations/peerOrganizations/scsmsr.co.in/peers/scsmsr.co.in/tls/ca.crt

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


# peer lifecycle chaincode commit \
# -o localhost:7050 \--ordererTLSHostnameOverride solapurhcareorderer.in \
# --tls --cafile $ORDERER_CA \
# --channelID $CHANNEL_NAME --name ${CC_NAME}  \
# --peerAddresses localhost:7051  \
# --tlsRootCertFiles $CIVIL_CA \
# --peerAddresses localhost:9051 \
# --tlsRootCertFiles $ASHWINI_CA \
# --version ${CC_VERSION} \
# --sequence ${CC_SEQUENCE} \
#  ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} 

fcn_call='{"Args":[]}'


peer chaincode invoke \
-o localhost:7050 --ordererTLSHostnameOverride orderer.solapurhcareorderer.in \
--tls --cafile $ORDERER_CA \
-C $CHANNEL_NAME \
-n ${CC_NAME} \
--peerAddresses localhost:9051 \
--tlsRootCertFiles $ASHWINI_CA \
--peerAddresses localhost:7051  \
--tlsRootCertFiles $CIVIL_CA \
--isInit -c ${fcn_call} >&log/invoke-log.txt



