#!/bin/bash

source ../registerEnroll.sh

createOrganization "ashwinihospital.co.in" "ashwini" "localhost:9054"

cp ../../organizations/fabric-ca/ashwinihospital-ca-chain.pem ../../organizations/peerOrganizations/ashwinihospital.co.in/peers/ashwinihospital.co.in/tls/ashwinihospital-ca-chain.pem
cp ../../organizations/fabric-ca/scsmsr-ca-chain.pem ../../organizations/peerOrganizations/ashwinihospital.co.in/peers/ashwinihospital.co.in/tls/scsmsr-ca-chain.pem

createOrderer "ashwinihospital.co.in" "ashwiniorderer" "localhost:9054"
cp ../../organizations/fabric-ca/ashwinihospital-ca-chain.pem ../../organizations/ordererOrganizations/orderer.ashwinihospital.co.in/orderers/orderer.ashwinihospital.co.in/tls/ashwinihospital-ca-chain.pem
cp ../../organizations/fabric-ca/scsmsr-ca-chain.pem ../../organizations/ordererOrganizations/orderer.ashwinihospital.co.in/orderers/orderer.ashwinihospital.co.in/tls/scsmsr-ca-chain.pem




