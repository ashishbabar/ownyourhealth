
. env-load.sh

rm /var/hyperledger/production -rf

# Generate genesis block
configtxgen -profile SampleDevModeSolo -channelID syschannel -outputBlock genesisblock -configPath $FABRIC_CFG_PATH -outputBlock $(pwd)/sampleconfig/genesisblock

#Start orderer in dev mode with profile SampleDevMode from sampleConfig
ORDERER_GENERAL_GENESISPROFILE=SampleDevModeSolo orderer
