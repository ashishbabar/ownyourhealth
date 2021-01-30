#!/bin/bash

source ../registerEnroll.sh
# Arguments
# 1. Organization name
# 2. User name for users
# 3. CA to register entities and users.
createOrderer "solapurhcareorderer.in" "shcorderer" "localhost:7054"
# cp ../../organizations/fabric-ca/ashwinihospital-ca-chain.pem ../../organizations/ordererOrganizations/orderer.solapurhcareorderer.in/orderers/orderer.solapurhcareorderer.in/tls/ashwinihospital-ca-chain.pem
# cp ../../organizations/fabric-ca/scsmsr-ca-chain.pem ../../organizations/ordererOrganizations/orderer.solapurhcareorderer.in/orderers/orderer.solapurhcareorderer.in/tls/scsmsr-ca-chain.pem
