
cd scripts/solapurhcareorderer/
docker-compose -f docker-compose-orderer.yaml down

cd ../civil/
docker-compose -f docker-compose-civil.yaml down

cd ../ashwini/
docker-compose -f docker-compose-ashwini.yaml down
