#!/bin/bash
export FABRIC_CFG_PATH=${PWD}/../../config/

configtxgen -profile TwoHospitals -outputAnchorPeersUpdate ../../channel-artifacts/civilMSPanchors.tx -channelID general-medicine-channel -asOrg SCSMSRMSP