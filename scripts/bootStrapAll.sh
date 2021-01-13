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

# Wait 
sleep 20

# Deploy chaincode on peer
./deploy-chaincode.sh

sleep 5 

cd ../civil
# Deploy chaincode on peer
./deploy-chaincode.sh

# Commit chaincode on peer
./commit-chaincode.sh

cd ../ashwini

./invoke-chaincode.sh

cd ../civil

./interact-chaincode.sh