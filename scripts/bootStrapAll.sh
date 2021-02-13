#!/bin/bash
#Bootstrap all peers

#Bootstrap orderer
cd solapurhcareorderer
./bootStrap.sh

# Bootstrap peer
cd ../ashwini
./bootStrap.sh

# Bootstrap peer
cd ../civil
./bootStrap.sh

#Orderer creates sys_channel trasaction and its genesis block
cd ../solapurhcareorderer
./channel_artifacts.sh

#Peer creates anchor peer artifacts
cd ../ashwini
./anchorPeerChannelArtifact.sh

#Peer creates anchor peer artifacts
cd ../civil
./anchorPeerChannelArtifact.sh

#Start network with all the certs and sys_channel transaction and its genesis block
cd ../../
./network.sh start

#Wait for all the service to start
sleep 20

#Create a channel from admin of the peer who have rights
cd scripts/civil
./create_channel.sh
#Peer will join the created channel
./join_channel.sh

#Another peer will join created channel
cd ../ashwini
./join_channel.sh

./setAnchorPeer.sh

cd ../civil

./setAnchorPeer.sh

cd ../ashwini
# Wait 
sleep 20

# Deploy chaincode on peer
./deploy-chaincode.sh "simpleContract" "simple-contract"
./deploy-chaincode.sh "healthContract" "health-contract"

sleep 5 

cd ../civil
# Deploy chaincode on peer
./deploy-chaincode.sh "simpleContract" "simple-contract"
./deploy-chaincode.sh "healthContract" "health-contract"

# Commit chaincode on peer
./commit-chaincode.sh "simpleContract" "simple-contract"
./commit-chaincode.sh "healthContract" "health-contract"

sleep 5 

cd ../ashwini
# Invoke chaincode on peer (NEED TO BE CHANGED AS PER CHAINCODE)
./invoke-chaincode.sh "simpleContract" "simple-contract"
./invoke-chaincode.sh "healthContract" "health-contract"

sleep 5 

cd ../civil
# Interact with installed chaincode (NEED TO BE CHANGED AS PER CHAINCODE)
./interact-chaincode.sh "simpleContract" "simple-contract"