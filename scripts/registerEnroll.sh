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
  fabric-ca-client enroll -u https://admin:adminpw@${3} --caname ca.${1} --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/'${3//:/-}'-ca-'${1//./-}'.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/'${3//:/-}'-ca-'${1//./-}'.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/'${3//:/-}'-ca-'${1//./-}'.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/'${3//:/-}'-ca-'${1//./-}'.pem
    OrganizationalUnitIdentifier: orderer' >${FABRIC_CA_CLIENT_HOME}/msp/config.yaml

  infoln "Register hospital fabric peer node"
  set -x
  fabric-ca-client register --caname ca.${1} --id.name ${2} --id.secret ${2}pw --id.type peer --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register hospital fabric user"
  set -x
  fabric-ca-client register --caname ca.${1} --id.name ${2}user1 --id.secret ${2}user1pw --id.type client --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the hospital organization admin"
  set -x
  fabric-ca-client register --caname ca.${1} --id.name ${2}admin --id.secret ${2}adminpw --id.type admin --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers
  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}

  infoln "Generate the hospital msp"
  set -x
  fabric-ca-client enroll -u https://${2}:${2}pw@${3} --caname ca.${1} -M ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/msp --csr.hosts ${1} --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/msp/config.yaml ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/msp/config.yaml

  infoln "Generate the hospital tls certificates"
  set -x
  fabric-ca-client enroll -u https://${2}:${2}pw@${3} --caname ca.${1} -M ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls --enrollment.profile tls --csr.hosts ${1} --csr.hosts localhost --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/ca.crt
  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/signcerts/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/server.crt
  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/keystore/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/server.key

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/msp/tlscacerts
  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/msp/tlscacerts/ca.crt

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/tlsca
  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/tlsca/tlsca.${1}-cert.pem

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/ca
  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/peers/${1}/msp/cacerts/* ${FABRIC_ORG_HOME}/peerOrganizations/${1}/ca/${1}-cert.pem

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users
  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/${2}User1@${1}

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://${2}user1:${2}user1pw@${3} --caname ca.${1} -M ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/${2}User1@${1}/msp --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/msp/config.yaml ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/${2}User1@${1}/msp/config.yaml

  mkdir -p ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/Admin@${1}

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://${2}admin:${2}adminpw@${3} --caname ca.${1} -M ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/Admin@${1}/msp --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/peerOrganizations/${1}/msp/config.yaml ${FABRIC_ORG_HOME}/peerOrganizations/${1}/users/Admin@${1}/msp/config.yaml

}

function createOrderer() {
  export FABRIC_ORG_HOME=${PWD}/../../organizations
  ORDERER_NAME=orderer.${1}
  infoln "Enroll the CA admin"
  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}

  export FABRIC_CA_CLIENT_HOME=${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@${3} --caname ca.${1} --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/'${3//:/-}'-ca-'${1//./-}'.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/'${3//:/-}'-ca-'${1//./-}'.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/'${3//:/-}'-ca-'${1//./-}'.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/'${3//:/-}'-ca-'${1//./-}'.pem
    OrganizationalUnitIdentifier: orderer' >${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/msp/config.yaml

  infoln "Register orderer"
  set -x
  fabric-ca-client register --caname ca.${1} --id.name ${2}orderer --id.secret ${2}ordererpw --id.type orderer --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the orderer admin"
  set -x
  fabric-ca-client register --caname ca.${1} --id.name ${2}ordererAdmin --id.secret ${2}ordererAdminpw --id.type admin --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers
  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}

  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}

  infoln "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://${2}orderer:${2}ordererpw@${3} --caname ca.${1} -M ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/msp --csr.hosts ${ORDERER_NAME} --csr.hosts localhost --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/msp/config.yaml ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/msp/config.yaml

  infoln "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://${2}orderer:${2}ordererpw@${3} --caname ca.${1} -M ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/tls --enrollment.profile tls --csr.hosts ${ORDERER_NAME} --csr.hosts localhost --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/tls/ca.crt
  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/tls/signcerts/* ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/tls/server.crt
  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/tls/keystore/* ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/tls/server.key

  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/msp/tlscacerts
  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/msp/tlscacerts/tlsca.${ORDERER_NAME}-cert.pem

  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/msp/tlscacerts
  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/orderers/${ORDERER_NAME}/tls/tlscacerts/* ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/msp/tlscacerts/tlsca.${ORDERER_NAME}-cert.pem

  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/users
  mkdir -p ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/users/Admin@${ORDERER_NAME}

  infoln "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://${2}ordererAdmin:${2}ordererAdminpw@${3} --caname ca.${1} -M ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/users/Admin@${ORDERER_NAME}/msp --tls.certfiles ${FABRIC_ORG_HOME}/fabric-ca/${1}/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/msp/config.yaml ${FABRIC_ORG_HOME}/ordererOrganizations/${ORDERER_NAME}/users/Admin@${ORDERER_NAME}/msp/config.yaml

}
