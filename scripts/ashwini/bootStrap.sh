#!/bin/bash
ORG=ashwinihospital.co.in
PEER=opd.ashwinihospital.co.in
P0PORT=9051
ANCHORPEER=anchor.ashwinihospital.co.in
ANCHORPOPORT=9053
CAPORT=9054
MSP="AshwiniHospitalMSP"
CA="ca.ashwinihospital.co.in"
PEERPEM=../../organizations/peerOrganizations/${ORG}/tlsca/tlsca.${ORG}-cert.pem
CAPEM=../../organizations/peerOrganizations/${ORG}/ca/${ORG}-cert.pem

source ../registerEnroll.sh

createOrganization ${ORG} "ashwinipeer" "localhost:9054" "opd.${ORG}"
createOrganization ${ORG} "ashwinianchor" "localhost:9054" "anchor.${ORG}"

# cp ../../organizations/fabric-ca/ashwinihospital-ca-chain.pem ../../organizations/peerOrganizations/ashwinihospital.co.in/peers/ashwinihospital.co.in/tls/ashwinihospital-ca-chain.pem
# cp ../../organizations/fabric-ca/scsmsr-ca-chain.pem ../../organizations/peerOrganizations/ashwinihospital.co.in/peers/ashwinihospital.co.in/tls/scsmsr-ca-chain.pem

createOrderer ${ORG} "ashwiniorderer" "localhost:9054"
# cp ../../organizations/fabric-ca/ashwinihospital-ca-chain.pem ../../organizations/ordererOrganizations/orderer.ashwinihospital.co.in/orderers/orderer.ashwinihospital.co.in/tls/ashwinihospital-ca-chain.pem
# cp ../../organizations/fabric-ca/scsmsr-ca-chain.pem ../../organizations/ordererOrganizations/orderer.ashwinihospital.co.in/orderers/orderer.ashwinihospital.co.in/tls/scsmsr-ca-chain.pem

# Generate ccp configuration file
source ../generatePeerConfig.sh

# rm ../../organizations/peerOrganizations/${ORG}/${PEER}.json
# rm ../../organizations/peerOrganizations/${ORG}/${PEER}.yaml

echo "$(json_ccp $ORG $P0PORT $CAPORT $MSP $CA $PEER $ANCHORPEER $ANCHORPOPORT $PEERPEM $CAPEM )" > ../../organizations/peerOrganizations/${ORG}/${PEER}.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $MSP $CA $PEER $ANCHORPEER $ANCHORPOPORT $PEERPEM $CAPEM )" > ../../organizations/peerOrganizations/${ORG}/${PEER}.yaml


