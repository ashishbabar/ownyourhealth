export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=${PWD}

export ORDERER_CA=${PWD}/../../organizations/ordererOrganizations/solapurhcareorderer.in/orderers/solapurhcareorderer.in/msp/tlscacerts/tlsca.solapurhcareorderer.in-cert.pem
export PEER0_ORG1_CA=${PWD}/../../organizations/peerOrganizations/scsmsr.co.in/peers/scsmsr.co.in/tls/ca.crt

# export CORE_PEER_LOCALMSPID="SCSMSRMSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../../organizations/ordererOrganizations/solapurhcareorderer.in/orderers/solapurhcareorderer.in/msp/tlscacerts/tlsca.solapurhcareorderer.in-cert.pem
# export CORE_PEER_MSPCONFIGPATH=${PWD}/../../organizations/ordererOrganizations/solapurhcareorderer.in/users/Admin@solapurhcareorderer.in/msp

export CORE_PEER_LOCALMSPID="SCSMSRMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
export CORE_PEER_MSPCONFIGPATH=${PWD}/../../organizations/peerOrganizations/scsmsr.co.in/users/Admin@scsmsr.co.in/msp
export CORE_PEER_ADDRESS=localhost:7051

peer channel create \
-o localhost:7050 \
-c general-medicine-channel \
--ordererTLSHostnameOverride solapurhcareorderer.in  \
-f ../../channel-artifacts/channel.tx  \
--outputBlock ../../channel-artifacts/general-medicine-channel.block  \
--tls --cafile $ORDERER_CA >&log.txt \
