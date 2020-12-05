
. env-load.sh

#Start the peer in dev mode with peerChaincodeDev flag
FABRIC_LOGGING_SPEC=chaincode=debug CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052 peer node start --peer-chaincodedev=true

#Create channel configuration
configtxgen -channelID ch1 -outputCreateChannelTx ch1.tx -profile SampleSingleMSPChannel -configPath $FABRIC_CFG_PATH

# Create channel using created config file which will generate channel genesis block
peer channel create -o 127.0.0.1:7050 -c ch1 -f ch1.tx

# Join this peer using above create genesis block
peer channel join -b ch1.block