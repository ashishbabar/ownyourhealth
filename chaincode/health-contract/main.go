package main

import (
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

func main(){
	healthContract := new(HealthContract)

	cc, err := contractapi.NewChaincode(healthContract)

	if err != nil {
		panic(err.Error())
	}

	if err := cc.Start(); err != nil {
		panic(err.Error())
	}
}