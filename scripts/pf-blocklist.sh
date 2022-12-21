#!/usr/bin/env bash
#
# Downloads IP addresses and ranges for blocking with PF:
#   1) Published lists of ad/malware hosts
#   2) You can add other custom ones
# Includes configuration for dnscrypt-proxy

#set -x

sudo mkdir /etc/pf
touch /etc/pf/blocklist
sudo cp -p /etc/pf.conf /etc/pf.conf.bak
threats=pf-threats.$(date +%F)
blocklist=pf-blocklist.$(date +%F)
sudo whoami >/dev/null || exit 1

printf "Current rules: "
sudo pfctl -t blocklist -T show | wc -l

action=""
while [[ -z "${action}" ]] ;
do read -n 1 -p "Continue? (y/n) " action
done
printf "\n"

if [[ "${action}" =~ ^([yY])$ ]] ; then
    rm $threats $blocklist 2>/dev/null
    touch $threats
    
    printf "Checking threats ..."
    curl -sq \
    "https://pgl.yoyo.org/adservers/iplist.php?ipformat=&showintro=0&mimetype=plaintext" \
    "https://www.binarydefense.com/banlist.txt" \
    "https://rules.emergingthreats.net/blockrules/compromised-ips.txt" \
    "https://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt" \
    "https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset" \
    "https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level2.netset" \
    "https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level3.netset" \
    "https://isc.sans.edu/api/threatlist/shodan/shodan.txt" | \
    grep -Ev "^192\.168\.|^10\.|172\.16\.|127\.0\.0\.0|0\.0\.0\.0|^#|#$" | \
    grep -E "^[0-9]" >> $threats
    wc -l $threats
    
    sort $threats | uniq > $blocklist
    wc -l $blocklist
    
    if [[ ! -s $blocklist ]] ; then
        printf "Error: empty blocklist\n" ; exit 1
    fi
    
    sudo cp -v /etc/pf/blocklist /etc/pf/blocklist.$(date +%F) && sudo cp -v ./$blocklist /etc/pf/blocklist
    sudo pfctl -e -f /etc/pf.conf
    printf "\nnew rules: "
    sudo pfctl -t blocklist -T show | wc -l
fi
