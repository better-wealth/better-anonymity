#!/usr/bin/env bash

set -e

# FIREWALL
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2;
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled 1

sudo pmset -a destroyfvkeyonstandby 1;
sudo pmset -a hibernatemode 25;
sudo pmset -a powernap 0;
sudo pmset -a standby 0;
sudo pmset -a standbydelay 0;
sudo pmset -a autopoweroff 0;
defaults write com.apple.screensaver askForPassword -int 1;
defaults write com.apple.screensaver askForPasswordDelay -int 0;
defaults write com.apple.finder AppleShowAllFiles -bool true;
chflags nohidden ~/Library;
defaults write NSGlobalDomain AppleShowAllExtensions -bool true;
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false;
defaults write com.apple.CrashReporter DialogType none;
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | sudo tee -a /etc/hosts;


# FILEVAULT
fdesetup status
fdesetup enable

# System Integrity Protection
csrutil status


https://blog.neilsabol.site/post/quickly-easily-adding-pf-packet-filter-firewall-rules-macos-osx/

Note that for the packet to be forwarded, you need to enable it with sysctl or set it permanently in sysctl.conf (see man pfctl):

$ sudo sysctl net.inet.ip.forwarding=1


1

Most programmatic PF needs can be solved with either PF tables or rule anchors, or even a combination of both. Only in extreme cases you would ever need to recur to the low level device interface. So the first step is to try to solve your task approaching these solutions in order, only go to the next if the previous one did not work:

    PF tables
    Rule anchors
    Low level device interface

The first two options are extensively explained in the pf.conf man page. Once you have your rules, tables, and anchors in place you can modify them with pfctl. You should be able to achieve 99% of the tasks you'll ever need to be performed by PF with these first two features.

Add the following into a file called pf.rules:

wifi = "en0"
ether = "en7"
set block-policy drop
set fingerprints "/etc/pf.os"
set ruleset-optimization basic
set skip on lo0
scrub in all no-df
table <blocklist> persist
block in log
block in log quick from no-route to any
block log on $wifi from { <blocklist> } to any
block log on $wifi from any to { <blocklist> }
antispoof quick for { $wifi $ether }
pass out proto tcp from { $wifi $ether } to any keep state
pass out proto udp from { $wifi $ether } to any keep state
pass out proto icmp from $wifi to any keep state

Then use the following commands to manipulate the firewall:

    sudo pfctl -e -f pf.rules to enable the firewall and load the configuration
    sudo pfctl -d to disable the firewall
    sudo pfctl -t blocklist -T add 1.2.3.4 to add an IP address to the blocklist
    sudo pfctl -t blocklist -T show to view the blocklist
    sudo ifconfig pflog0 create to create an interface for logging
    sudo tcpdump -ni pflog0 to view filtered packets

Unless you're already familiar with packet filtering, spending too much time configuring pf is not recommended. It is also probably unnecessary if your Mac is behind a NAT on a secure home network.

It is possible to use the pf firewall to block network access to entire ranges of network addresses, for example to a whole organization:

Query Merit RADb for the list of networks in use by an autonomous system, like Facebook:

$ whois -h whois.radb.net '!gAS32934'

Copy and paste the list of networks returned into the blocklist command:

$ sudo pfctl -t blocklist -T add 31.13.24.0/21 31.13.64.0/24 157.240.0.0/16

Confirm the addresses were added:

$ sudo pfctl -t blocklist -T show
No ALTQ support in kernel
ALTQ related functions disabled
   31.13.24.0/21
   31.13.64.0/24
   157.240.0.0/16

Confirm network traffic is blocked to those addresses (note that DNS requests will still work):

$ dig a +short facebook.com
157.240.2.35

$ curl --connect-timeout 5 -I http://facebook.com/
*   Trying 157.240.2.35...
* TCP_NODELAY set
* Connection timed out after 5002 milliseconds
* Closing connection 0
curl: (28) Connection timed out after 5002 milliseconds

$ sudo tcpdump -tqni pflog0 'host 157.240.2.35'
IP 192.168.1.1.62771 > 157.240.2.35.80: tcp 0
IP 192.168.1.1.62771 > 157.240.2.35.80: tcp 0
IP 192.168.1.1.62771 > 157.240.2.35.80: tcp 0
IP 192.168.1.1.62771 > 157.240.2.35.80: tcp 0
IP 192.168.1.1.162771 > 157.240.2.35.80: tcp 0

Outgoing TCP SYN packets are blocked, so a TCP connection is not established and thus a Web site is effectively blocked at the IP layer.

To use pf to audit "phone home" behavior of user and system-level processes, see fix-macosx/net-monitor. See drduh/config/scripts/pf-blocklist.sh for more inspiration.

# sudo cp -p /etc/pf.conf /etc/pf.conf.bak