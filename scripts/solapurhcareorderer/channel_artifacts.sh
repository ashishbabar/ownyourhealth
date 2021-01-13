export FABRIC_CFG_PATH=${PWD}/../../config


configtxgen -profile TwoHospitalsOrdererGenesis -channelID sys-channel -outputBlock ../../channel-artifacts/genesis.block

configtxgen -profile TwoHospitals -outputCreateChannelTx ../../channel-artifacts/channel.tx -channelID general-medicine-channel