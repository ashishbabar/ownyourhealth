#!/bin/bash
export IMAGE_TAG=latest

if [[ $1 = "stop" ]]; then
cd scripts/solapurhcareorderer/
docker-compose -f docker-compose-orderer.yaml stop
docker-compose -f docker-compose-orderer.yaml rm -f

cd ../civil/
docker-compose -f docker-compose-civil.yaml stop 
docker-compose -f docker-compose-civil.yaml rm -f 

cd ../ashwini/
docker-compose -f docker-compose-ashwini.yaml stop
docker-compose -f docker-compose-ashwini.yaml rm -f

else
cd scripts/solapurhcareorderer/
docker-compose -f docker-compose-orderer.yaml up -d
sleep 4
cd ../civil/
docker-compose -f docker-compose-civil.yaml up -d couchdb.opd.scsmsr.co.in
docker-compose -f docker-compose-civil.yaml up -d opd.scsmsr.co.in
docker-compose -f docker-compose-civil.yaml up -d anchor.scsmsr.co.in
docker-compose -f docker-compose-civil.yaml up -d orderer.scsmsr.co.in1
sleep 4

cd ../ashwini/
docker-compose -f docker-compose-ashwini.yaml up -d couchdb.opd.ashwinihospital.co.in
docker-compose -f docker-compose-ashwini.yaml up -d opd.ashwinihospital.co.in
docker-compose -f docker-compose-ashwini.yaml up -d anchor.ashwinihospital.co.in
docker-compose -f docker-compose-ashwini.yaml up -d orderer.ashwinihospital.co.in1
fi

