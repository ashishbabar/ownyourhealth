sudo rm /var/hyperledger/production -rf

docker volume rm $(docker volume ls --filter dangling=true -q)
