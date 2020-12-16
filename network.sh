export IMAGE_TAG=latest

if [[ $1 = "stop" ]]; then
MODE="down"
else
MODE="up -d -V"
fi
cd scripts/solapurhcareorderer/
docker-compose -f docker-compose-orderer.yaml $MODE

cd ../civil/
docker-compose -f docker-compose-civil.yaml $MODE

cd ../ashwini/
docker-compose -f docker-compose-ashwini.yaml $MODE
