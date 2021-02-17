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

func (hc *HealthContract) ReadPatient(ctx contractapi.TransactionContextInterface, id string) (*Patient, error) {
	patientJSON, err := ctx.GetStub().GetState(id)
	if err != nil {
		return nil, fmt.Errorf("failed to read from world state: %v", err)
	}
	if patientJSON == nil {
		return nil, fmt.Errorf("the patient %s does not exist", id)
	}

	var patient Patient
	err = json.Unmarshal(patientJSON, &patient)
	if err != nil {
		return nil, err
	}

	return &patient, nil
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

func (hc *HealthContract) ReadSymptoms(ctx contractapi.TransactionContextInterface, id string) (*Illness, error) {
	symptomsJSON, err := ctx.GetStub().GetState(id)
	if err != nil {
		return nil, fmt.Errorf("failed to read from world state: %v", err)
	}
	if symptomsJSON == nil {
		return nil, fmt.Errorf("the symptoms %s does not exist", id)
	}

	var symptoms Illness
	err = json.Unmarshal(symptomsJSON, &symptoms)
	if err != nil {
		return nil, err
	}

	return &symptoms, nil
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

func (hc *HealthContract) ReadDiagnosis(ctx contractapi.TransactionContextInterface, id string) (*Diagnosis, error) {
	diagnosisJSON, err := ctx.GetStub().GetState(id)
	if err != nil {
		return nil, fmt.Errorf("failed to read from world state: %v", err)
	}
	if diagnosisJSON == nil {
		return nil, fmt.Errorf("the diagnosis %s does not exist", id)
	}

	var diagnosis Diagnosis
	err = json.Unmarshal(diagnosisJSON, &diagnosis)
	if err != nil {
		return nil, err
	}

	return &diagnosis, nil
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

func (hc *HealthContract) ReadPrescription(ctx contractapi.TransactionContextInterface, id string) (*Prescription, error) {
	prescriptionJSON, err := ctx.GetStub().GetState(id)
	if err != nil {
		return nil, fmt.Errorf("failed to read from world state: %v", err)
	}
	if prescriptionJSON == nil {
		return nil, fmt.Errorf("the prescription %s does not exist", id)
	}

	var prescription Prescription
	err = json.Unmarshal(prescriptionJSON, &prescription)
	if err != nil {
		return nil, err
	}

	return &prescription, nil
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
