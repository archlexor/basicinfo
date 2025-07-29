#! /bin/bash

GREEN='\033[0;32m'
BLUE='\e[34m'
RED='\e[31m'
END='\033[0m'

echo -e "Enter your domain(example.com): "
read DOMAIN

mkdir rawdata

#---------------------------------------FUNCTIONS----------------------------------------

nslookup_scan() {
	echo -e "${RED}nslookup enumeration.............${END}"
	nslookup $DOMAIN > rawdata/nslookup_scan.txt
	echo -e "${GREEN}Completed."
}

nmap_scan() {
	echo -e "${RED}nmap enumeration.............${END}"
	nmap -sV -sC -v $DOMAIN > rawdata/nmap_scan.txt
	echo -e "${GREEN}Completed."
}


whois_scan() {	
	echo -e "${RED}whois enumeration.............${END}"
	whois $DOMAIN > rawdata/whois_scan.txt
	echo -e "${GREEN}Completed."
}


crtsh_scan() {
	echo -e "${RED}crtsh enumeration.............${END}"
	curl https://crt.sh/?q=${DOMAIN} -o rawdata/crtsh.txt
	echo -e "${GREEN}Completed."
}


subfinder_scan() {
	echo -e "${RED}subfinder enumeration...............${END}"
	subfinder -d ${DOMAIN} -all -recursive > rawdata/subfinder_scan.txt
	echo -e"${GREEN}Completed.${END}"
}


repeat() {
	for i in {1..50}; do echo -n "-"; done
}

#----------------------------------------------------------------------------------------

nslookup_scan
nmap_scan
whois_scan
crtsh_scan
subfinder_scan

NSLOOKUP_FILE="${pwd}rawdata/nslookup_scan.txt"
NMAP_FILE="${pwd}rawdata/nmap_scan.txt"
WHOIS_FILE="${pwd}rawdata/whois_scan.txt"
CRTSH_FILE="${pwd}rawdata/crtsh.txt"
SUBFINDER_FILE="${pwd}rawdata/subfinder_scan.txt"
SUBDOMAIN="${pwd}rawdata/subdomains"


#filtered format for nslookup
repeat 
echo -e "\n${GREEN}nslookup${END}" 
repeat 
echo -e ""
awk '(NR>4) {print}' "$NSLOOKUP_FILE" 


#filtered format for nmap lookup
repeat 
echo -e "\n${GREEN}nmap lookup${END}" 
repeat 
echo -e ""
echo -e "${BLUE}Open Ports and Services:${END}"
awk '/^[0-9]+\/tcp[ \t]+open/ {
    port = $1
    service = $3
    version = (NF > 3) ? substr($0, index($0, $4)) : "Unknown"
    print "Port: " port "		Service: " service "		Service Version: " version
}
' "$NMAP_FILE"

echo -e "\n${BLUE}Closed or Filtered Ports:${END}"
awk '/^[0-9]+\/tcp[ \t]+(closed|filtered)/ {
    port = $1
    state = $2
    service = $3
    print "Port: " port "		Service: " service "		Status: " state
}
' "$NMAP_FILE"


#filtered format for whois lookup
echo -e ""
repeat 
echo -e "\n${GREEN}whois lookup${END}" 
repeat 
echo -e ""
 awk '{
    line = $0
    sub(/^[ \t]+/, "", line)         # Remove leading spaces
    if (line ~ /^Domain Name:/ ||
        (line ~ /^Registrar:/ && line !~ /Abuse/) ||
        line ~ /^Creation Date:/ ||
        line ~ /^Expiry Date:/ ||
        line ~ /^Name Server:/ ||
        line ~ /^Domain Status:/) {
        
        if (!seen[line]++) {
            print line
        }
    }  
}' "$WHOIS_FILE"


#filtered format for crtsh and subfinder lookup
echo -e ""
repeat 
echo -e "\n${GREEN}crtsh and subfinder lookup(subdomains)${END}" 
repeat 
echo -e ""
awk '{          
  while (match($0, /<BR>([^<]+)<\/TD>/, a)) {
    print a[1]
    $0 = substr($0, RSTART + RLENGTH)
  }
}' "$CRTSH_FILE"| sort -u > rawdata/subdomains.txt
sort -u $SUBDOMAIN $SUBFINDER_FILE


repeat 
echo -e ""
echo -e "${RED}ALL the raw data is saved under rawdata directory${END}"
echo -e "${RED}Also for further use of this code, do make sure to delete the rawdata directory${END}" 
