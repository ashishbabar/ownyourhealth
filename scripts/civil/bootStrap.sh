#!/bin/bash
ORG=scsmsr.co.in
PEER=opd.scsmsr.co.in
P0PORT=7051
ANCHORPEER=anchor.scsmsr.co.in
ANCHORPOPORT=7053
CAPORT=8054
MSP="SCSMSRMSP"
CA="ca.scsmsr.co.in"
PEERPEM=../../organizations/peerOrganizations/${ORG}/tlsca/tlsca.${ORG}-cert.pem
CAPEM=../../organizations/peerOrganizations/${ORG}/ca/${ORG}-cert.pem

source ../registerEnroll.sh

createOrganization ${ORG} "civilpeer" "localhost:8054" "opd.${ORG}"
createOrganization ${ORG} "civilanchor" "localhost:8054" "anchor.${ORG}"


createOrderer ${ORG} "civilorderer" "localhost:8054"

# Generate ccp configuration file
source ../generatePeerConfig.sh


echo "$(json_ccp $ORG $P0PORT $CAPORT $MSP $CA $PEER $ANCHORPEER $ANCHORPOPORT $PEERPEM $CAPEM )" > ../../organizations/peerOrganizations/${ORG}/${PEER}.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $MSP $CA $PEER $ANCHORPEER $ANCHORPOPORT $PEERPEM $CAPEM )" > ../../organizations/peerOrganizations/${ORG}/${PEER}.yaml
