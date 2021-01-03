export IMAGE_TAG=latest

cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-ca.yaml stop
docker-compose -f docker-compose-ca.yaml rm -f

cd ../../civil/ca
docker-compose -f docker-compose-ca.yaml stop
docker-compose -f docker-compose-ca.yaml rm -f

cd ../../ashwini/ca
docker-compose -f docker-compose-ca.yaml down
# docker-compose -f docker-compose-ca.yaml rm -f


cd ../../../

sudo rm organizations/* -rf

pwd 
./ca1.sh start

sudo chown ashish:ashish organizations -R