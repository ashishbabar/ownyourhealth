export IMAGE_TAG=latest

cd scripts/solapurhcareorderer/
docker-compose -f docker-compose-orderer.yaml up -d

cd ../civil/
docker-compose -f docker-compose-civil.yaml up -d

cd ../ashwini/
docker-compose -f docker-compose-ashwini.yaml up -d
