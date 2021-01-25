#!/bin/bash
export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=${PWD}/../../config

CHANNEL_NAME=general-medicine-channel
export ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/orderer.solapurhcareorderer.in/orderers/orderer.solapurhcareorderer.in/msp/tlscacerts/tlsca.orderer.solapurhcareorderer.in-cert.pem
CIVIL_CA=${PWD}/../../organizations/peerOrganizations/scsmsr.co.in/peers/scsmsr.co.in/tls/ca.crt
ASHWINI_CA=${PWD}/../../organizations/peerOrganizations/ashwinihospital.co.in/peers/ashwinihospital.co.in/tls/ca.crt


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

peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} --output json >&log/commit-ready-log.txt

peer lifecycle chaincode commit \
-o localhost:7050 \
--ordererTLSHostnameOverride orderer.solapurhcareorderer.in \
--tls --cafile $ORDERER_CA \
--channelID $CHANNEL_NAME --name ${CC_NAME}  \
--peerAddresses localhost:7051  \
--tlsRootCertFiles $CIVIL_CA \
--peerAddresses localhost:9051 \
--tlsRootCertFiles $ASHWINI_CA \
--version ${CC_VERSION} \
--sequence ${CC_SEQUENCE} \
 ${INIT_REQUIRED} ${CC_END_POLICY} ${CC_COLL_CONFIG} 

peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}