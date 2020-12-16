export IMAGE_TAG=latest


if [ $1 = "stop" ]; then
MODE="down"
else
MODE="up -d"
fi

cd scripts/solapurhcareorderer/ca
docker-compose -f docker-compose-ca.yaml $MODE

cd ../../civil/ca
docker-compose -f docker-compose-ca.yaml $MODE

cd ../../ashwini/ca
docker-compose -f docker-compose-ca.yaml $MODE
