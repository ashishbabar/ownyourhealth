export IMAGE_TAG=latest


if [ $1 = "stop" ]; then
cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-solapurhcare-ca.yaml stop
docker-compose -f docker-compose-solapurhcare-ca.yaml rm -f

cd ../../civil/ca
docker-compose -f docker-compose-civil-ca.yaml stop
docker-compose -f docker-compose-civil-ca.yaml rm -f

cd ../../ashwini/ca
docker-compose -f docker-compose-ashwini-ca.yaml down
else
cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-solapurhcare-ca.yaml up -d 

cd ../../civil/ca
docker-compose -f docker-compose-civil-ca.yaml up -d

cd ../../ashwini/ca
docker-compose -f docker-compose-ashwini-ca.yaml up -d
fi


