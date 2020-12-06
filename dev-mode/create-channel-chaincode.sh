
. env-load.sh

rm ch1.tx -f
rm ch1.block -f

#Create channel configuration
configtxgen -channelID ch1 -outputCreateChannelTx ch1.tx -profile SampleSingleMSPChannel -configPath $FABRIC_CFG_PATH

# Create channel using created config file which will generate channel genesis block
peer channel create -o 127.0.0.1:7050 -c ch1 -f ch1.tx

# Join this peer using above create genesis block
peer channel join -b ch1.block

cd ./simple-contract

pwd 

rm go.mod -f
rm go.sum -f
rm simple-contract -f
go mod init gitlab.com/ashishbabar/ownyourhealth/dev-mode/simple-contract
go get -u github.com/hyperledger/fabric-contract-api-go
go mod vendor
go build
 
cd ..

CORE_CHAINCODE_LOGLEVEL=debug CORE_PEER_TLS_ENABLED=false CORE_CHAINCODE_ID_NAME=simpleContract:1.0 ./simple-contract/simple-contract -peer.address 127.0.0.1:7052
