#!/bin/bash
export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=${PWD}/../../config

export CHANNEL_NAME=general-medicine-channel
export ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/orderer.solapurhcareorderer.in/orderers/orderer.solapurhcareorderer.in/msp/tlscacerts/tlsca.orderer.solapurhcareorderer.in-cert.pem
export ASHWINI_CA=${PWD}/../../organizations/peerOrganizations/ashwinihospital.co.in/peers/opd.ashwinihospital.co.in/tls/ca.crt

# export CORE_PEER_LOCALMSPID="SCSMSRMSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../../organizations/ordererOrganizations/orderer.ashwinihospital.co.in/orderers/orderer.ashwinihospital.co.in/msp/tlscacerts/tlsca.ashwinihospital.co.in-cert.pem
# export CORE_PEER_MSPCONFIGPATH=${PWD}/../../organizations/ordererOrganizations/ashwinihospital.co.in/users/Admin@ashwinihospital.co.in/msp

export CORE_PEER_LOCALMSPID="AshwiniHospitalMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$ASHWINI_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/../../organizations/peerOrganizations/ashwinihospital.co.in/users/Admin@ashwinihospital.co.in/msp
export CORE_PEER_ADDRESS=localhost:9051

# peer channel join -b ../../channel-artifacts/$CHANNEL_NAME.block >&log/channel-join-log.txt

peer channel update \
-o localhost:7050 \
-c $CHANNEL_NAME \
--ordererTLSHostnameOverride orderer.solapurhcareorderer.in  \
-f ../../channel-artifacts/ashwiniMSPanchors.tx  \
--tls $CORE_PEER_TLS_ENABLED \
--cafile $ORDERER_CA >&log/setAnchor-log.txt 
