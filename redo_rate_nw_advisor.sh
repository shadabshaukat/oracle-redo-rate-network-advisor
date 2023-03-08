#!/bin/bash

# Result output file
RESULT=/home/oracle/file.csv

# Define ANSI color codes for green and red
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Run the SQL query and save the output to a file
sqlplus / as sysdba << EOF > "$RESULT" 2>&1
  SET SERVEROUTPUT ON
  SET LINESIZE 1000
  SET PAGESIZE 0
  SET COLSEP ','
  SET FEEDBACK OFF
  SET TRIMSPOOL ON
  SPOOL $RESULT
SELECT MAX(AVERAGE) FROM DBA_HIST_SYSMETRIC_SUMMARY WHERE METRIC_NAME='Redo Generated Per Sec';
EOF

# Get the redo rate from the second line of the file
REDO_RATE=$(sed -n '2p' "$RESULT" | awk -F, '{print $1}' | tr -d ' ')
#REDO_RATE=100000000

# Calculate the required bandwidth in Mbps and MB/s
REQUIRED_BANDWIDTH=$(echo "scale=6; ((${REDO_RATE} / 0.75) * 8) / 1000000" | bc -l)
REQUIRED_BANDWIDTH_Gbps=$(echo "scale=6; ${REQUIRED_BANDWIDTH} / 1000" | bc -l)
REQUIRED_BANDWIDTH_MB=$(echo "scale=6; ${REQUIRED_BANDWIDTH} / 8" | bc -l)
REQUIRED_BANDWIDTH_GB=$(echo "scale=6; ${REQUIRED_BANDWIDTH_MB} / 1000" | bc -l)

# Output the results
echo ""
echo "+++++++++++++++++++++++++++++++++++++++++"
echo "Redo rate in bytes per sec: ${REDO_RATE}"
echo "+++++++++++++++++++++++++++++++++++++++++"
echo "Required bandwidth in Mbps: ${REQUIRED_BANDWIDTH} Mbps"
echo "Required bandwidth in Gbps: ${REQUIRED_BANDWIDTH_Gbps} Gbps"
echo "-----------------------------------------"
echo "Required bandwidth in MB/s: ${REQUIRED_BANDWIDTH_MB} MB/s"
echo "Required bandwidth in GB/s: ${REQUIRED_BANDWIDTH_GB} GB/s"
echo "+++++++++++++++++++++++++++++++++++++++++"
echo ""

# Determine the required Network Connection type for Data Guard
if (( $(echo "${REQUIRED_BANDWIDTH} <= 250" | bc -l) )); then
  NETWORK_TYPE="OCI IPSec VPN 250 Mbps"
  COLOR=${RED}
elif (( $(echo "${REQUIRED_BANDWIDTH} >= 250 && ${REQUIRED_BANDWIDTH} <= 1000" | bc -l) )); then
  NETWORK_TYPE="OCI 1Gbps Fastconnect"
  COLOR=${RED}
elif (( $(echo "${REQUIRED_BANDWIDTH} >= 1000 && ${REQUIRED_BANDWIDTH} <= 3000" | bc -l) )); then
  NETWORK_TYPE="OCI 3Gbps Fastconnect"
  COLOR=${RED}
elif (( $(echo "${REQUIRED_BANDWIDTH} >= 3000 && ${REQUIRED_BANDWIDTH} <= 10000" | bc -l) )); then
  NETWORK_TYPE="OCI 10Gbps Fastconnect"
  COLOR=${RED}
else
  NETWORK_TYPE="OCI 100Gbps Fastconnect"
  COLOR=${RED}
fi

# Output the Network Connection type in red color
echo -e "${COLOR}Recommended Network Connection Type for Data Guard: ${GREEN}${NETWORK_TYPE}${NC}"
