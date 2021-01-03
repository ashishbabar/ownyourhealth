#!/bin/bash

source ../registerEnroll.sh
# Arguments
# 1. Organization name
# 2. 
createOrganization "ashwinihospital.co.in" "ashwini" "localhost:9054"

createOrderer "ashwinihospital.co.in" "ashwiniorderer" "localhost:9054"