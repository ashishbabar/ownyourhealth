#!/bin/bash

source ../registerEnroll.sh
# Arguments
# 1. Organization name
# 2. 
createOrganization "scsmsr.co.in" "civil" "localhost:8054"
cp ../../organizations/fabric-ca/scsmsr-ca-chain.pem ../../organizations/peerOrganizations/scsmsr.co.in/peers/scsmsr.co.in/tls/scsmsr-ca-chain.pem


createOrderer "scsmsr.co.in" "civilorderer" "localhost:8054"
cp ../../organizations/fabric-ca/scsmsr-ca-chain.pem ../../organizations/ordererOrganizations/orderer.scsmsr.co.in/orderers/orderer.scsmsr.co.in/tls/scsmsr-ca-chain.pem
