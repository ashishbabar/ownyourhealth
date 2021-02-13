#Create Ashwini Hospital conf file

discover --configFile ashwini-conf.yaml \
--peerTLSCA ../organizations/peerOrganizations/ashwinihospital.co.in/peers/opd.ashwinihospital.co.in/tls/ca.crt  \
--userKey ../organizations/peerOrganizations/ashwinihospital.co.in/users/ashwinipeerUser1@ashwinihospital.co.in/msp/keystore/2deda5cd4ff11671b1c44da959032a0cf8651d11fbce0d28f288eb60b1d54f40_sk \
--userCert ../organizations/peerOrganizations/ashwinihospital.co.in/users/ashwinipeerUser1@ashwinihospital.co.in/msp/signcerts/cert.pem \
--MSP AshwiniHospitalMSP saveConfig


#Create Civil Hospital conf file

discover --configFile civil-conf.yaml \
--peerTLSCA ../organizations/peerOrganizations/scsmsr.co.in/peers/opd.scsmsr.co.in/tls/ca.crt  \
--userKey ../organizations/peerOrganizations/scsmsr.co.in/users/civilpeerUser1@scsmsr.co.in/msp/keystore/5ca062a941d7ad5f149253fb765492a825af24524686dc374ec053ca34e198b1_sk \
--userCert ../organizations/peerOrganizations/scsmsr.co.in/users/civilpeerUser1@scsmsr.co.in/msp/signcerts/cert.pem \
--MSP SCSMSRMSP saveConfig

# Get peer memebership info from discovery service
discover --configFile ashwini-conf.yaml peers --channel general-medicine-channel --server localhost:9051 > ashwini-peer-membership.json

#Get Config info from discover service
discover --configFile ashwini-conf.yaml config --channel general-medicine-channel --server localhost:9051 > ashwini-config.json

#Get endorser info from discovery service
discover --configFile ashwini-conf.yaml endorsers --channel general-medicine-channel --server localhost:9051 --chaincode sampleContract > ashwini-endorser-json.json