#!/bin/bash

source ../registerEnroll.sh

createOrganization "scsmsr.co.in" "civil" "localhost:8054"

cp ../../organizations/fabric-ca/scsmsr-ca-chain.pem ../../organizations/peerOrganizations/scsmsr.co.in/peers/scsmsr.co.in/tls/scsmsr-ca-chain.pem
cp ../../organizations/fabric-ca/ashwinihospital-ca-chain.pem ../../organizations/peerOrganizations/scsmsr.co.in/peers/scsmsr.co.in/tls/ashwinihospital-ca-chain.pem

createOrderer "scsmsr.co.in" "civilorderer" "localhost:8054"
cp ../../organizations/fabric-ca/scsmsr-ca-chain.pem ../../organizations/ordererOrganizations/orderer.scsmsr.co.in/orderers/orderer.scsmsr.co.in/tls/scsmsr-ca-chain.pem
cp ../../organizations/fabric-ca/ashwinihospital-ca-chain.pem ../../organizations/ordererOrganizations/orderer.scsmsr.co.in/orderers/orderer.scsmsr.co.in/tls/ashwinihospital-ca-chain.pem
