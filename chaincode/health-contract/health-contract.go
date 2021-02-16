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
	SId         string `json:"sid"`
	PId         string `json:"pid"`
	DocId       string `json:"docid"`
	DateTime    string `json:"datetime"`
	Name        string `json:"name"`
	Description string `json:"description"`
}

type Diagnosis struct {
	DId         string `json:"did"`
	SId         string `json:"sid"`
	PId         string `json:"pid"`
	DocId       string `json:"docid"`
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
	PscId       string `json:"pscid"`
	DId         string `json:"did"`
	PId         string `json:"pid"`
	DocId       string `json:"docid"`
	DateTime    string `json:"datetime"`
	Catagory    string `json:"catagory"`
	Description string `json:"description"`
	CustomUsage string `json:"customusage"`
	Quantity    int    `json:"quantity"`
}

type Permissions struct {
	PerID    string `json:"perid"`
	DocId    string `json:"docid"`
	PId      string `json:"pid"`
	Catagory string `json:"catagory"`
	Hospital string `json:"hospital"`
}

func (hc *HealthContract) AdmitPatient(ctx contractapi.TransactionContextInterface, newPatientString string) error {
	var newPatient Patient
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

	patientJSON, err := json.Marshal(newPatient)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(newPatient.PId, patientJSON)
}

func (hc *HealthContract) NoteSymptoms(ctx contractapi.TransactionContextInterface, newSymptomsString string) error {
	var newSymptoms Illness
	err := json.Unmarshal([]byte(newSymptomsString), &newSymptoms)
	if err != nil {
		return err
	}

	exists, err := hc.AssetExists(ctx, newSymptoms.SId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("the symptoms %s already exists", newSymptoms.SId)
	}

	symptomJSON, err := json.Marshal(newSymptoms)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(newSymptoms.SId, symptomJSON)

}

func (hc *HealthContract) DiagnosePatient(ctx contractapi.TransactionContextInterface, newDiagnosisString string) error {
	var newDiagnosis Diagnosis
	err := json.Unmarshal([]byte(newDiagnosisString), &newDiagnosis)
	if err != nil {
		return err
	}

	exists, err := hc.AssetExists(ctx, newDiagnosis.DId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("the diagnosis %s already exists", newDiagnosis.DId)
	}

	diagnosisJSON, err := json.Marshal(newDiagnosis)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(newDiagnosis.DId, diagnosisJSON)
}

func (hc *HealthContract) WritePrescription(ctx contractapi.TransactionContextInterface, newPrescriptionString string) error {
	var newPrescription Prescription
	err := json.Unmarshal([]byte(newPrescriptionString), &newPrescription)
	if err != nil {
		return err
	}

	exists, err := hc.AssetExists(ctx, newPrescription.PscId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("the prescription %s already exists", newPrescription.PscId)
	}

	prescriptionJSON, err := json.Marshal(newPrescription)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(newPrescription.PscId, prescriptionJSON)

}

// AssetExists returns true when patient with given ID exists in world state
func (hc *HealthContract) AssetExists(ctx contractapi.TransactionContextInterface, id string) (bool, error) {
	assetJSON, err := ctx.GetStub().GetState(id)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return assetJSON != nil, nil
}
