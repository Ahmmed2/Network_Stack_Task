#!/bin/bash

# Bash Script to Analyze Network Traffic

# Input: Path to the Wireshark pcap file
declare pcap_file=$1            # capture input from terminal.

# Function to extract information from the pcap file
analyze_traffic() {

    # Revealing the png file 
    # tcpdump -qns 0 -X -r "$pcap_file"

    declare -i Total_Packet 

    # Delete All file Contents 
    echo -n "" > Packets.txt 
    echo -n "" > Report.txt

    # Searching for HTTPS/TLS 
    if [ "$(tshark -r "$pcap_file" -Y "ssl.record.version == 0x0303" | wc -l )"  -eq 0 ]; then
    echo "No HTTPS/TLS packets found." >> Report.txt
    else
    tshark -r "$pcap_file" -Y "ssl.record.version == 0x0303" >> Packets.txt
    fi
    
    # Counting Number of Packets in TLS.txt
     echo "Number of HTTPS/TLS packets:"     >> Report.txt
     wc -l "Packets.txt" | awk '{print $1}'  >> Report.txt
     

    # Searching for HTTP
    if [ "$(tshark -r "$pcap_file" -Y "http" | wc -l )"  -eq 0 ]; then
    echo "No HTTP packets found." >> Report.txt
    else
    tshark -r "$pcap_file" -Y "http" >> Packets.txt
    fi
    
    # Counting Number of Packets in HTTP.txt 
    echo "Number of HTTP packets: "     >> Report.txt
    wc -l "Packets.txt" | awk '{print $1}' >> Report.txt

    # Total Number of Packets 
    Total_Packet=$(wc -l < Packets.txt)
    echo "Total Number of Packets are " >> Report.txt
    echo "$Total_Packet " >> Report.txt

    # Top 3 IP-adresses and Number of occurence 
    echo "Top 3 IP-adress of source are : " >> Report.txt
    awk '{print $3}' Packets.txt | sort | uniq -c | awk '{$1=$1;print}' >> Report.txt
    echo "Top 3 IP-adress of Destination are : " >> Report.txt
    awk '{print $5}' Packets.txt | sort | uniq -c | awk '{$1=$1;print}' >> Report.txt

    
}

function main () {

analyze_traffic "$1"

}

main "$1"

