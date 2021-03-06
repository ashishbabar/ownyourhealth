#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $9)
    local CP=$(one_line_pem ${10})
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s/\${MSP}/$4/" \
        -e "s/\${CA}/$5/" \
        -e "s/\${PEER}/$6/" \
        -e "s#\${ANCHORPEER}#$7#" \
        -e "s#\${ANCHORPOPORT}#$8#" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ../../config/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $9)
    local CP=$(one_line_pem ${10})
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s/\${MSP}/$4/" \
        -e "s/\${CA}/$5/" \
        -e "s/\${PEER}/$6/" \
        -e "s/\${ANCHORPEER}/$7/" \
        -e "s/\${ANCHORPOPORT}/$8/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ../../config/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}
