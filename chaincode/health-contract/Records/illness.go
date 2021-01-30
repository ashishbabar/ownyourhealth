package main

import (
	"errors"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type Illness struct{
	Sid int `json:"sid"`
	Pid int `json:"pid"`
	Name string `json:"name"`
	Description string `json:"description"`
}

func (i * )
