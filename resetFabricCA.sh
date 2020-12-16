export IMAGE_TAG=latest

cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-ca.yaml down -v

cd ../../civil/ca
docker-compose -f docker-compose-ca.yaml down -v

cd ../../ashwini/ca
docker-compose -f docker-compose-ca.yaml down -v

cd ../../../

sudo rm organizations/* -rf

pwd 
cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-ca.yaml up -d

cd ../../civil/ca
docker-compose -f docker-compose-ca.yaml up -d

cd ../../ashwini/ca
docker-compose -f docker-compose-ca.yaml up -d

cd ../../../

sudo chown ashish:ashish organizations -R