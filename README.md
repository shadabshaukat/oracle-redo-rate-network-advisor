# Oracle Redo Rate Network Advisor
This is a shell script to calculate the peak redo rate and give recommendation on which Network type to use to create Hybrid DR from On-Premise to OCI

The script uses SQL*Plus to connect to the database and run a SQL query to get the maximum redo rate. The redo rate is then used to calculate the required bandwidth in Mbps and MB/s, and based on the required bandwidth, the script recommends a network connection type for Data Guard.

## Explanation

   - The script begins by setting the RESULT variable to the path of a CSV file where the output of the SQL query will be saved.

   - The script uses SQL*Plus to run a SQL query to get the maximum redo rate and save the output to the CSV file.

   - The script then uses sed and awk to extract the redo rate from the second line of the CSV file.

   -  The script calculates the required bandwidth in Mbps and MB/s using the redo rate.

   - The script recommends a network connection type for Data Guard based on the required bandwidth and outputs it in red color.

   - The script also includes some error handling and logging.

## Prerequisites

    - The script must be run as the Oracle user or as a user with sysdba privileges.
    - SQL*Plus must be installed on the system.
    - The bc command-line calculator must be installed on the system.

## Usage

### 1. Clone the repo

    git clone https://github.com/shadabshaukat/oracle-redo-rate-network-advisor.git

### 2. Change to the oracle-redo-rate-network-advisor directory:

    cd oracle-redo-rate-network-advisor
    
### 3. Run the Script

    ./redo_rate_nw_advisor.sh

### Sample Output

    +++++++++++++++++++++++++++++++++++++++++
    Redo rate in bytes per sec: 48863.5089
    +++++++++++++++++++++++++++++++++++++++++
    Required bandwidth in Mbps: .521210 Mbps
    Required bandwidth in Gbps: .000521 Gbps
    -----------------------------------------
    Required bandwidth in MB/s: .065151 MB/s
    Required bandwidth in GB/s: .000065 GB/s
    +++++++++++++++++++++++++++++++++++++++++

    Recommended Network Connection Type for Data Guard: OCI IPSec VPN 250 Mbps
    
## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Disclaimer

The script is provided as-is and is not guaranteed to work on all systems or with all versions of Oracle. Use at your own risk.
