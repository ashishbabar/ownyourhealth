export FABRIC_CFG_PATH=${PWD}

configtxgen -profile TwoHospitals -outputAnchorPeersUpdate ../../channel-artifacts/ashwiniMSPanchors.tx -channelID general-medicine-channel -asOrg AshwiniHospitalMSP