export FABRIC_CFG_PATH=${PWD}

configtxgen -profile TwoHospitals -outputAnchorPeersUpdate ../../channel-artifacts/civilMSPanchors.tx -channelID general-medicine-channel -asOrg SCSMSR