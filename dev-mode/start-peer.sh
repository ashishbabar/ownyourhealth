
. env-load.sh

#Start the peer in dev mode with peerChaincodeDev flag
FABRIC_LOGGING_SPEC=chaincode=debug CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052 peer node start --peer-chaincodedev=true