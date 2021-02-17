#!/bin/bash
export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=${PWD}/../../config

export CHANNEL_NAME=general-medicine-channel
export ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/orderer.solapurhcareorderer.in/orderers/orderer.solapurhcareorderer.in/msp/tlscacerts/tlsca.orderer.solapurhcareorderer.in-cert.pem
export CIVIL_CA=${PWD}/../../organizations/peerOrganizations/scsmsr.co.in/peers/opd.scsmsr.co.in/tls/ca.crt

export CORE_PEER_LOCALMSPID="SCSMSRMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$CIVIL_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/../../organizations/peerOrganizations/scsmsr.co.in/users/Admin@scsmsr.co.in/msp
export CORE_PEER_ADDRESS=localhost:7051

peer channel join -b ../../channel-artifacts/$CHANNEL_NAME.block >&log/channel-join-log.txt

# export CHANNEL_NAME=general-medicine-channel
# export ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/orderer.solapurhcareorderer.in/orderers/orderer.solapurhcareorderer.in/msp/tlscacerts/tlsca.orderer.solapurhcareorderer.in-cert.pem
export CIVIL_CA=${PWD}/../../organizations/peerOrganizations/scsmsr.co.in/peers/anchor.scsmsr.co.in/tls/ca.crt


export CORE_PEER_ADDRESS=localhost:7053

peer channel join -b ../../channel-artifacts/$CHANNEL_NAME.block >&log/anchor-channel-join-log.txt

