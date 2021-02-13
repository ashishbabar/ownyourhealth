#!/bin/bash
export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=${PWD}

export ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/orderer.solapurhcareorderer.in/orderers/orderer.solapurhcareorderer.in/msp/tlscacerts/tlsca.orderer.solapurhcareorderer.in-cert.pem

export CORE_PEER_LOCALMSPID="SolapurHealthcareMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../../organizations/ordererOrganizations/orderer.solapurhcareorderer.in/orderers/orderer.solapurhcareorderer.in/msp/tlscacerts/tlsca.orderer.solapurhcareorderer.in-cert.pem
export CORE_PEER_MSPCONFIGPATH=${PWD}/../../organizations/ordererOrganizations/solapurhcareorderer.in/users/Admin@solapurhcareorderer.in/msp

peer channel create \
-o localhost:7050 \
-c general-medicine-channel \
--ordererTLSHostnameOverride solapurhcareorderer.in  \
-f ../../channel-artifacts/channel.tx  \
--outputBlock ../channel-artifacts/general-medicine-channel.block  \
--tls --cafile $ORDERER_CA >&log.txt \
