cd ../simple-contract

. env-load.sh

go mod vendor

go build

CORE_CHAINCODE_ID_NAME=mycc:0 CORE_PEER_TLS_ENABLED=false ./contract-tutorial -peer.address peer:7052
