#!/bin/bash

source ../registerEnroll.sh
# Arguments
# 1. Organization name
# 2. 
createOrganization "scsmsr.co.in" "civil" "localhost:8054"

createOrderer "scsmsr.co.in" "civilorderer" "localhost:8054"

