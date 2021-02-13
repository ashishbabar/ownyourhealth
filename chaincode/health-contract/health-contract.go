package main

import (
	"encoding/json"
	// "errors"
	"fmt"
	// "strconv"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type HealthContract struct {
	contractapi.Contract
}

type Doctor struct {
	DocId    int    `json:"docid"`
	Hospital string `json:"hospital"`
}

type Patient struct {
	PId             string `json:"pid"`
	UId             int    `json:"uid"`
	Name            string `json:"name"`
	Birthday        string `json:"birthday"`
	Gender          string `json:"gender"`
	Pasthistory     string `json:"pasthistory"`
	Allergichistory string `json:"allergichistory"`
	Height          int    `json:"height"`
	Weight          int    `json:"weight"`
	Status          string `json:"status"`
}

type Illness struct {
	SId         int    `json:"sid"`
	PId         int    `json:"pid"`
	DocId       int    `json:"docid"`
	DateTime    string `json:"datetime"`
	Name        string `json:"name"`
	Description string `json:"description"`
}

type Diagnosis struct {
	DId         int    `json:"did"`
	SId         int    `json:"sid"`
	PId         int    `json:"pid"`
	DocId       int    `json:"docid"`
	DateTime    string `json:"datetime"`
	Catagory    string `json:"catagory"`
	Description string `json:"description"`
	Temperature int    `json:"temperature"`
	Systolicbp  int    `json:"systolicbp"`
	Diastolicbp int    `json:"diastolicbp"`
	HeartRate   int    `json:"heartrate"`
	Advice      string `json:"advice"`
}

type Prescription struct {
	PscId       int    `json:"pscid"`
	DId         int    `json:"did"`
	PId         int    `json:"pid"`
	DocId       int    `json:"docid"`
	DateTime    string `json:"datetime"`
	Catagory    string `json:"catagory"`
	Description string `json:"description"`
	CustomUsage string `json:"customusage"`
	Quantity    int    `json:"quantity"`
}

type Permissions struct {
	PerID    int    `json:"perid"`
	DocId    int    `json:"docid"`
	PId      int    `json:"pid"`
	Catagory string `json:"catagory"`
	Hospital string `json:"hospital"`
}

func (hc *HealthContract) AdmitPatient(ctx contractapi.TransactionContextInterface, newPatientString string /* , id string, uid string, name string, birthday string, gender string, pasthistory string, allergichistory string, height int, weight int, status string */) error {
	var newPatient Patient
	// newPatientData := []byte(newPatientString)
	err := json.Unmarshal([]byte(newPatientString), &newPatient)
	if err != nil {
		return err
	}

	exists, err := hc.AssetExists(ctx, newPatient.PId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("the patient %s already exists", newPatient.PId)
	}
	// pid, err := strconv.Atoi(args[0])
	// if err != nil {
	// return err
	// }

	// uid, err := strconv.Atoi(args[0])
	// if err != nil {
	// return err
	// }

	// height, err := strconv.Atoi(args[0])
	// if err != nil {
	// return err
	// }

	// weight, err := strconv.Atoi(args[0])
	// if err != nil {
	// return err
	// }

	// patient := Patient{
	// PId:				pid,
	// UId:				uid,
	// Name:				args[2],
	// Birthday:			args[3],
	// Gender:				args[4],
	// Pasthistory:		args[5],
	// Allergichistory:	args[6],
	// Height:				height,
	// Weight:				weight,
	// Status:				args[9],
	//  }
	patientJSON, err := json.Marshal(newPatient)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(newPatient.PId, patientJSON)
}

// func (hc *HealthContract) NoteSymptoms(ctx contractapi.TransactionContextInterface,args []string/* , id string, pid string, docid string, name string, description string */) error {
// 	exists, err := hc.AssetExists(ctx,args[0])
// 	if err != nil {
// 		return err
// 	}
// 	if exists {
// 		return fmt.Errorf("Symptom for patient %s already exists", args[1])
// 	}

// 	symptoms := Illness{
// 		SId:				args[0],
// 		PId:				args[1],
// 		DocId:				args[2],
// 		Name:				args[3],
// 		Description:		args[4],
// 	}
// 	symptomsJSON, err := json.Marshal(symptoms)
// 	if err !=nil {
// 		return err
// 	}

// 	return ctx.GetStub().PutState(id, symptomsJSON);

// }

// func (hc *HealthContract) DiagnosePatient(ctx contractapi.TransactionContextInterface,args []string,/*  id string, pid string, docid string, name string, description string */) error {
// 	exists, err := hc.AssetExists(ctx,args[0])
// 	if err != nil {
// 		return err
// 	}
// 	if exists {
// 		return fmt.Errorf("Diagnosis for patient %s already exists", args[1])
// 	}

// 	diagnosis := Diagnosis{
// 		DId:				args[0],
// 		SId:				args[1],
// 		PId:				args[2],
// 		DocId:				args[3],
// 		DateTime:			args[4],
// 		Catagory:			args[5],
// 		Description:		args[6],
// 		Temperature:		args[7],
// 		Systolicbp:			args[8],
// 		Diastolicbp:		args[9],
// 		HeartRate:			args[10],
// 		Advice:				args[11],
// 	}
// 	diagnosisJSON, err := json.Marshal(diagnosis)
// 	if err !=nil {
// 		return err
// 	}

// 	return ctx.GetStub().PutState(args[0], diagnosisJSON);

// }

// func (hc *HealthContract) WritePrescription(ctx contractapi.TransactionContextInterface,args []string,/*  id string, pid string, docid string, name string, description string */) error {
// 	exists, err := hc.AssetExists(ctx,args[0])
// 	if err != nil {
// 		return err
// 	}
// 	if exists {
// 		return fmt.Errorf("Prescription for diagnosis %s already exists", args[1])
// 	}

// 	prescription := Prescription{
// 		PscId:				args[0],
// 		DId:				args[1],
// 		PId:				args[2],
// 		DocId:				args[3],
// 		DateTime:			args[4],
// 		Catagory:			args[5],
// 		Description:		args[6],
// 		CustomUsage:		args[7],
// 		Quantity:			args[8],
// 	}
// 	prescriptionJSON, err := json.Marshal(prescription)
// 	if err !=nil {
// 		return err
// 	}

// 	return ctx.GetStub().PutState(args[0], prescriptionJSON);

// }

// func (sc *HealthContract) Update(ctx contractapi.TransactionContextInterface, key string, value string) error {
// 	existingRecord, err := ctx.GetStub().GetState(key)

// 	if err != nil {
// 		return errors.New("Unable to interact with world state")
// 	}

// 	if existingRecord == nil {
// 		return fmt.Errorf("Cannot update world state pair with key %s. Does not exists", key)
// 	}

// 	err = ctx.GetStub().PutState(key, []byte(value))

// 	if err != nil {
// 		return errors.New("Unable to interact with world state")
// 	}

// 	return nil
// }

// func (hc *HealthContract) QueryPatient(ctx contractapi.TransactionContextInterface, pid string){
// 	Patient, err := ctx.GetStub().GetState(pid)
// 	if err != nil {
// 		return "",errors.New("Unable to interact with world state")
// 	}

// 	if existingRecord == nil {
// 		return "",fmt.Errorf("Cannot read from world state pair with id %s. Does not exists", id)
// 	}

// 	return string(Patient), nil
// }

// func (sc *HealthContract) Read(ctx contractapi.TransactionContextInterface, key string) (string, error) {
// 	existingRecord, err := ctx.GetStub().GetState(key)

// 	if err != nil {
// 		return "",errors.New("Unable to interact with world state")
// 	}

// 	if existingRecord == nil {
// 		return "",fmt.Errorf("Cannot read from world state pair with key %s. Does not exists", key)
// 	}

// 	return string(existingRecord), nil
// }
// AssetExists returns true when patient with given ID exists in world state
func (hc *HealthContract) AssetExists(ctx contractapi.TransactionContextInterface, id string) (bool, error) {
	assetJSON, err := ctx.GetStub().GetState(id)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return assetJSON != nil, nil
}
