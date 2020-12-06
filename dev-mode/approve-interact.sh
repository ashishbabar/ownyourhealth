
. env-load.sh

# Approve and commit the chaincode definition
peer lifecycle chaincode approveformyorg  -o 127.0.0.1:7050 --channelID ch1 --name simpleContract --version 1.0 --sequence 1 --init-required --signature-policy "OR ('SampleOrg.member')" --package-id simpleContract:1.0

peer lifecycle chaincode checkcommitreadiness -o 127.0.0.1:7050 --channelID ch1 --name simpleContract --version 1.0 --sequence 1 --init-required --signature-policy "OR ('SampleOrg.member')"

peer lifecycle chaincode commit -o 127.0.0.1:7050 --channelID ch1 --name simpleContract --version 1.0 --sequence 1 --init-required --signature-policy "OR ('SampleOrg.member')" --peerAddresses 127.0.0.1:7051


sleep 5s 

# Instantiate and interact with chaincode
CORE_PEER_ADDRESS=127.0.0.1:7051 peer chaincode invoke -o 127.0.0.1:7050 -C ch1 -n simpleContract -c '{"Args":[]}' --isInit

sleep 5s 

CORE_PEER_ADDRESS=127.0.0.1:7051 peer chaincode invoke -o 127.0.0.1:7050 -C ch1 -n simpleContract -c '{"Args":["Create","key1","value1"]}'

sleep 5s 

CORE_PEER_ADDRESS=127.0.0.1:7051 peer chaincode invoke -o 127.0.0.1:7050 -C ch1 -n simpleContract -c '{"Args":["Read","key1"]}'