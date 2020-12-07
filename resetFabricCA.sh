docker-compose -f docker-compose-ca.yaml down

sudo rm organizations/* -rf

docker-compose -f docker-compose-ca.yaml up -d

sudo chown ashish:ashish organizations -R