#!/bin/sh

touch /var/log/dnsmasq-dhcp
echo "$(date) -- ${1} ${2} ${3} ${4}" >> /var/log/dnsmasq-dhcp