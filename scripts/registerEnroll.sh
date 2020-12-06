#!/bin/bash

# source scriptUtils.sh
function infoln() {
  println "${C_BLUE}${1}${C_RESET}"
}

function println() {
  echo -e "$1"
}

function createOrganization() {

  infoln "Enroll the CA admin"
  # mkdir -p organizations/peerOrganizations/${1}/

  export FABRIC_ORG_HOME=${PWD}/../../organizations

  export FABRIC_CA_CLIENT_HOME=${FABRIC_ORG_HOME}/peerOrganizations/${1}
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname solapur_healthcare_ca --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-solapur_healthcare_ca.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-solapur_healthcare_ca.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-solapur_healthcare_ca.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-solapur_healthcare_ca.pem
    OrganizationalUnitIdentifier: orderer' >${FABRIC_CA_CLIENT_HOME}/msp/config.yaml

  infoln "Register ashwini hospital fabric peer node"
  set -x
  fabric-ca-client register --caname solapur_healthcare_ca --id.name ${2} --id.secret ${2}pw --id.type peer --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register ashwini hospital fabric user"
  set -x
  fabric-ca-client register --caname solapur_healthcare_ca --id.name ${2}user1 --id.secret ${2}user1pw --id.type client --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the ashwini hospital organization admin"
  set -x
  fabric-ca-client register --caname solapur_healthcare_ca --id.name ${2}admin --id.secret ${2}adminpw --id.type admin --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers
  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}

  infoln "Generate the ashwini hospital msp"
  set -x
  fabric-ca-client enroll -u https://${2}:${2}pw@localhost:7054 --caname solapur_healthcare_ca -M ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/msp --csr.hosts ${1} --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/msp/config.yaml ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/msp/config.yaml

  infoln "Generate the ashwini hospital tls certificates"
  set -x
  fabric-ca-client enroll -u https://${2}:${2}pw@localhost:7054 --caname solapur_healthcare_ca -M ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls --enrollment.profile tls --csr.hosts ${1} --csr.hosts localhost --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/ca.crt
  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/signcerts/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/server.crt
  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/keystore/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/server.key

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/msp/tlscacerts
  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/msp/tlscacerts/ca.crt

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/tlsca
  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/tlsca/tlsca.solapur_healthcare.in-cert.pem

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/ca
  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/msp/cacerts/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/ca/solapurhealthcare.in-cert.pem

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users
  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/${2}User1@${1}

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://${2}user1:${2}user1pw@localhost:7054 --caname solapur_healthcare_ca -M ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/${2}User1@${1}/msp --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/msp/config.yaml ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/${2}User1@${1}/msp/config.yaml

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/Admin@${1}

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://${2}admin:${2}adminpw@localhost:7054 --caname solapur_healthcare_ca -M ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/Admin@${1}/msp --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/msp/config.yaml ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/Admin@${1}/msp/config.yaml

}

function createOrderer() {
  export FABRIC_ORG_HOME=${PWD}/../../organizations

  infoln "Enroll the CA admin"
  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${1}

  export FABRIC_CA_CLIENT_HOME=${FABRIC_ORG_HOME}/ordererOrganizations/${1}
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname solapur_healthcare_ca --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-solapur_healthcare_ca.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-solapur_healthcare_ca.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-solapur_healthcare_ca.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-solapur_healthcare_ca.pem
    OrganizationalUnitIdentifier: orderer' >${FABRIC_ORG_HOME}/ordererOrganizations/${1}/msp/config.yaml

  infoln "Register orderer"
  set -x
  fabric-ca-client register --caname solapur_healthcare_ca --id.name ${2}orderer --id.secret ${2}ordererpw --id.type orderer --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the orderer admin"
  set -x
  fabric-ca-client register --caname solapur_healthcare_ca --id.name ${2}ordererAdmin --id.secret ${2}ordererAdminpw --id.type admin --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers
  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}

  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}

  infoln "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://${2}orderer:${2}ordererpw@localhost:7054 --caname solapur_healthcare_ca -M ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/msp --csr.hosts ${1} --csr.hosts localhost --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/msp/config.yaml ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/msp/config.yaml

  infoln "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://${2}orderer:${2}ordererpw@localhost:7054 --caname solapur_healthcare_ca -M ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/tls --enrollment.profile tls --csr.hosts ${1} --csr.hosts localhost --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/tls/ca.crt
  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/tls/signcerts/* ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/tls/server.crt
  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/tls/keystore/* ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/tls/server.key

  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/msp/tlscacerts
  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/msp/tlscacerts/tlsca.${1}-cert.pem

  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/msp/tlscacerts
  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/orderers/${1}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/msp/tlscacerts/tlsca.${1}-cert.pem

  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/users
  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/users/Admin@${1}

  infoln "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://${2}ordererAdmin:${2}ordererAdminpw@localhost:7054 --caname solapur_healthcare_ca -M ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/users/Admin@${1}/msp --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/solapurhealthcare.in/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/msp/config.yaml ${FABRIC_ORG_HOME}/ordererOrganizations/${1}/users/Admin@${1}/msp/config.yaml

}
