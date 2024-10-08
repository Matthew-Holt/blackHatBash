#!/bin/bash

# Send a notification when new host is discovered
KNOWN_HOSTS="10.10.10.10-hosts.txt" # change as needed
NETWORK="10.10.10.0/24" # Change as needed
INTERFACE="INTERFACE" # Change as needed 
FROM_ADDR="account1@email.com" # Change as needed
TO_ADDR="account2@email.com" # Change as needed

while true; do
    echo "Running ARP scan against ${NETWORK}..."

    sudo arp-scan -x -I ${INTERFACE} ${NETWORK} | while read -r line; do
        host=$(echo "${line}" | awk '{print $1}')
        if ! grep -q  "${host}" "${KNOWN_HOSTS}"; then
            echo "New host identified: ${host}"
            echo "${host}" >> "${KNOWN_HOSTS}"
             sendemail -f "${FROM_ADDR}" \
                -t "${TO_ADDR}" \
                -u "ARP Scan Notification" \
                -m "A new host was found: ${host}"
        fi
    done

    sleep 10
done