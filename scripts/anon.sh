# Command+Option+P+R keys to clear NVRAM.

# set device name
sudo scutil --set ComputerName MacBook
sudo scutil --set LocalHostName MacBook

# FULL DISK ENCRYPTION
sudo fdesetup enable
sudo pmset -a destroyfvkeyonstandby 1
sudo pmset -a hibernatemode 25
sudo pmset -a powernap 0
sudo pmset -a standby 0
sudo pmset -a standbydelay 0
sudo pmset -a autopoweroff 0

#firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off
sudo pkill -HUP socketfilterfw

# INSTALL PRE-REQS
brew install autoconf automake cmake docbook gmp jansson libevent libtool llvm openssl pkg-config readline tor

# MAC ADDRESS
# brew install spoof-mac
brew install spoof-mac
sudo spoof-mac randomize en0
# OR
# networksetup -setairportpower en0 off
# sudo ifconfig en0 ether $(openssl rand -hex 6 | sed ‘s/(..)/\1:/g; s/.$//’)
# networksetup -detectnewhardware
# networksetup -setairportpower en0 on
curl https://raw.githubusercontent.com/feross/SpoofMAC/master/misc/local.macspoof.plist > local.macspoof.plist
cat local.macspoof.plist | sed "s|/usr/local/bin/spoof-mac.py|`which spoof-mac.py`|" | tee local.macspoof.plist
sudo cp local.macspoof.plist /Library/LaunchDaemons
cd /Library/LaunchDaemons
sudo chown root:wheel local.macspoof.plist
sudo chmod 0644 local.macspoof.plist

#captive portal
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false

#hosts
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | sudo tee -a /etc/hosts
wc -l /etc/hosts
egrep -ve "^#|^255.255.255.255|^127.|^0.|^::1|^ff..::|^fe80::" /etc/hosts | sort | uniq | egrep -e "[1,2]|::"
sudo dscacheutil -flushcache


brew install gnupg
brew install pinentry-mac
# $ curl -o ~/.gnupg/gpg.conf https://raw.githubusercontent.com/drduh/config/master/gpg.conf
# Make the directory
mkdir ~/.gnupg
# Tells GPG which pinentry program to use
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
# This tells gpg to use the gpg-agent
echo 'use-agent' > ~/.gnupg/gpg.conf
# $ curl -o ~/.gnupg/gpg.conf https://raw.githubusercontent.com/drduh/config/master/gpg.conf
echo 'export GPG_TTY=$(tty)' >> ~/.zshrc
source ~/.zshrc
chmod 700 ~/.gnupg
killall gpg-agent
gpg --full-gen-key
# Please select what kind of key you want:
#   (1) RSA and RSA (default)
#   (2) DSA and Elgamal
#   (3) DSA (sign only)
#   (4) RSA (sign only)
#Your selection? 4
#RSA keys may be between 1024 and 4096 bits long.
#What keysize do you want? (2048) 4096
#Requested keysize is 4096 bits
#Please specify how long the key should be valid.
#         0 = key does not expire
#      <n>  = key expires in n days
#      <n>w = key expires in n weeks
#      <n>m = key expires in n months
#      <n>y = key expires in n years
#Key is valid for? (0) 0
#Key does not expire at all
#Is this correct? (y/N) y
#
#You need a user ID to identify your key; the software constructs the user ID
#from the Real Name, Comment and Email Address in this form:
#    "Heinrich Heine (Der Dichter) <heinrichh@duesseldorf.de>"
#
#Real name: John Smith
#Email address: john.smith@fictionaladdress.com
#Comment:
#You selected this USER-ID:
#    "John Smith <john.smith@fictionaladdress.com>"
#
#Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
#You need a Passphrase to protect your secret key.
# List your keys
gpg -k
# Copy the text after the rsa4096/ and before the date generated and use the copied id in step 13:
gpg -K --keyid-format SHORT
sec rsa4096/######## YYYY-MM-DD [SC] [expires: YYYY-MM-DD]
# The export command below gives you the key you add to GitHub
gpg --armor --export <your key id>
git config --global gpg.program $(which gpg)
# The below command needs the fingerprint from step 10 above:
git config --global user.signingkey 1111111
git config --global commit.gpgsign true
# Login into Github.com and go to your settings, SSH and GPG Keys, and add your GPG key from the page.
#Ex: git commit -S -s -m "My Signed Commit"


#dnscrypt
# https://github.com/DNSCrypt/dnscrypt-proxy
# TRY: https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/utils/generate-domains-blocklist/generate-domains-blocklist.py
brew install dnscrypt-proxy
# brew info dnscrypt-proxy
# edit /usr/local/etc/dnscrypt-proxy.toml
# listen_addresses = ['127.0.0.1:5355', '[::1]:5355']
sudo brew services restart dnscrypt-proxy
sudo lsof +c 15 -Pni UDP:5355
#In the Right hand pane you'll see a box for 'dnscrypt-proxy' -- it's probably unchecked.
#You'll need to check the box.


# https://github.com/JayBrown/DNSCrypt-Menu
#
#    install dnscrypt-proxy version 2, e.g. with Homebrew (recommended): brew install dnscrypt-proxy
#        configure dnscrypt-proxy by editing the .toml configuration file
#    download the latest version of BitBar, currently at v2.0.0 beta 10
#        install and configure BitBar
#        quit BitBar
#    clone the DNSCrypt Menu GitHub repository and symlink DNSCryptMenu.30s.sh to your BitBar plugins folder
#        refresh clone for updates
#    install terminal-notifier (optional, recommended)
#    launch BitBar
# OR https://github.com/jedisct1/bitbar-dnscrypt-proxy-switcher/blob/master/dnscrypt-proxy-switcher.10s.sh

# obfs4proxy
brew install obfs4proxy
torrc.sample
cp /usr/local/etc/tor/torrc.sample /usr/local/etc/tor/torrc
# edit torrc 
# Using Bridges, obsf4
#UseBridges 1
#ClientTransportPlugin obfs4 exec /usr/local/bin/obfs4proxy managed

# send email to bridges@torproject.org with body `get transport obfs4` you can get new bridges.
# Or use https://bridges.torproject.org/options
# Paste the obsf4 bridges here and put Bridge in front of each.
#Bridge obfs4 85.2.12.181:13975 6796DCB... cert=mO0... iat-mode=0
#Bridge obfs4 90.187.118.49:8776 DDA45... cert=q7h... iat-mode=0
#Bridge obfs4 192.227.196.157:80 C5B48F... cert=mHeEajWhjVxpAJgraOQTJKQqS571+9NNyDEBEOc5wf4SJCDPk0SZF/mvT5+nw4vJzuMgUQ iat-mode=0

# PF

#dnsmasq
brew install dnsmasq
# /usr/local/etc/dnsmasq.conf
curl -o homebrew/etc/dnsmasq.conf https://raw.githubusercontent.com/drduh/config/master/dnsmasq.conf
sudo brew services start dnsmasq
sudo networksetup -setdnsservers "Wi-Fi" 127.0.0.1
# # Install dnsmasq 
# Configure resolver
#[ -d /etc/resolver ] || sudo mkdir -v /etc/resolver
#sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dnsmasq'
# configuring dnsmasq#
#sudo mkdir -p $(brew --prefix)/etc/
#cat > $(brew --prefix)/etc/dnsmasq.conf <<-EOF
#listen-address=127.0.0.1
#address=/.vbox/127.0.0.1
# keep nameserver order of resolv.conf
#strict-order
#EOF

#dnssec

#curl
curl -o ~/.curlrc https://raw.githubusercontent.com/drduh/config/master/curlrc

# tor
brew install tor

#privoxy
# https://www.privoxy.org/sf-download-mirror/Macintosh%20%28OS%20X%29/3.0.33%20%28stable%29/Privoxy%203.0.33%2064%20bit.pkg
# view current config at: https://www.privoxy.org/config/
brew install privoxy
brew services start privoxy
#checks:
# privoxy: http://p.p/, https://www.privoxy.org/config/
# tor: https://check.torproject.org/
# http://www.ip2location.com/


cp /usr/local/etc/privoxy/config /usr/local/opt/privoxy/sbin/
# add the following line into config file, it means forward filtered data to Tor.
#forward-socks4a / 127.0.0.1:9050 .

curl -o homebrew/etc/privoxy/config https://raw.githubusercontent.com/drduh/config/master/privoxy/config
curl -o homebrew/etc/privoxy/user.action https://raw.githubusercontent.com/drduh/config/master/privoxy/user.action

sudo brew services restart privoxy

#Gatekeeper
sudo chflags schg ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2

#metadata
sudo defaults delete /Library/Preferences/com.apple.Bluetooth.plist DeviceCache
sudo defaults delete /Library/Preferences/com.apple.Bluetooth.plist IDSPairedDevices
sudo defaults delete /Library/Preferences/com.apple.Bluetooth.plist PANDevices
sudo defaults delete /Library/Preferences/com.apple.Bluetooth.plist PANInterfaces
sudo defaults delete /Library/Preferences/com.apple.Bluetooth.plist SCOAudioDevices
sudo rm -rfv /var/spool/cups/c0*
sudo rm -rfv /var/spool/cups/tmp/*
sudo rm -rfv /var/spool/cups/cache/job.cache*
sudo defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
sudo defaults delete /Users/$USER/Library/Preferences/com.apple.iPod.plist Devices
sudo defaults delete /Library/Preferences/com.apple.iPod.plist "conn:128:Last Connect"
sudo defaults delete /Library/Preferences/com.apple.iPod.plist Devices
sudo rm -rfv /var/db/lockdown/*
qlmanage -r cache
qlmanage -r disablecache
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/exclusive
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-shm
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-wal
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/resetreason
rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.data
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.fraghandler
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/exclusive
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-shm
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-wal
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/resetreason
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.data
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.fraghandler
defaults delete ~/Library/Preferences/com.apple.finder.plist FXDesktopVolumePositions
defaults delete ~/Library/Preferences/com.apple.finder.plist FXRecentFolders
defaults delete ~/Library/Preferences/com.apple.finder.plist RecentMoveAndCopyDestinations
defaults delete ~/Library/Preferences/com.apple.finder.plist RecentSearches
defaults delete ~/Library/Preferences/com.apple.finder.plist SGTRecentFileSearches
sudo nvram -d 36C28AB5-6566-4C50-9EBD-CBB920F83843:current-network
sudo nvram -d 36C28AB5-6566-4C50-9EBD-CBB920F83843:preferred-networks
sudo nvram -d 36C28AB5-6566-4C50-9EBD-CBB920F83843:preferred-count
rm -rfv "~/Library/LanguageModeling/*" "~/Library/Spelling/*" "~/Library/Suggestions/*"
chmod -R 000 ~/Library/LanguageModeling ~/Library/Spelling ~/Library/Suggestions
chflags -R uchg ~/Library/LanguageModeling ~/Library/Spelling ~/Library/Suggestions
rm -rfv "~/Library/Application Support/Quick Look/*"
chmod -R 000 "~/Library/Application Support/Quick Look"
chflags -R uchg "~/Library/Application Support/Quick Look"
sudo rm -rfv /.DocumentRevisions-V100/*
sudo chmod -R 000 /.DocumentRevisions-V100
sudo chflags -R uchg /.DocumentRevisions-V100
rm -rfv "~/Library/Saved Application State/*"
rm -rfv "~/Library/Containers/<APPNAME>/Saved Application State"
chmod -R 000 "~/Library/Saved Application State/"
chmod -R 000 "~/Library/Containers/<APPNAME>/Saved Application State"
chflags -R uchg "~/Library/Saved Application State/"
chflags -R uchg "~/Library/Containers/<APPNAME>/Saved Application State"
rm -rfv "~/Library/Containers/<APP>/Data/Library/Autosave Information"
rm -rfv "~/Library/Autosave Information"
chmod -R 000 "~/Library/Containers/<APP>/Data/Library/Autosave Information"
chmod -R 000 "~/Library/Autosave Information"
chflags -R uchg "~/Library/Containers/<APP>/Data/Library/Autosave Information"
chflags -R uchg "~/Library/Autosave Information"
rm -rfv ~/Library/Assistant/SiriAnalytics.db
chmod -R 000 ~/Library/Assistant/SiriAnalytics.db
chflags -R uchg ~/Library/Assistant/SiriAnalytics.db
defaults delete ~/Library/Preferences/com.apple.iTunes.plist recentSearches
~/Library/Containers/com.apple.QuickTimePlayerX/Data/Library/Preferences/com.apple.QuickTimePlayerX.plist
~/Library/Containers/com.apple.appstore/Data/Library/Preferences/com.apple.commerce.knownclients.plist
~/Library/Preferences/com.apple.commerce.plist
~/Library/Preferences/com.apple.QuickTimePlayerX.plist

sudo ifconfig en0 ether $(openssl rand -hex 6 | sed 's%\(..\)%\1:%g; s%.$%%')

# screen lock
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

#expose hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

chflags nohidden ~/Library

#show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

#do NOT default to saving files to icloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

#disable crash reporter
defaults write com.apple.CrashReporter DialogType none

#disable Bonjour multicast advertisements
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool YES

# https://github.com/drduh/config/blob/master/scripts/macos-dns.sh
sudo scutil << EOF
get State:/Network/Service/gpd.pan/DNS
d.remove SearchDomains
d.remove ServerAddress
d.add ServerAddresses * 127.0.0.1 ::1
set State:/Network/Service/gpd.pan/DNS
exit
EOF


# https://github.com/drduh/config/blob/master/scripts/dnscrypt.sh
# https://github.com/cofyc/dnscrypt-wrapper
expiry=21
name=2.dnscrypt-cert.$(tr -dc '[:alnum:]' < /dev/urandom | fold -w20 | head -n1)
rm -f 0.crt 0.key public.key secret.key
pkill -9 dnscrypt-wrapper
dnscrypt-wrapper --gen-provider-keypair --provider-name=$name \
  --ext-address=$(curl -s https://icanhazip.com/) 2>/dev/null | grep sdns
dnscrypt-wrapper --gen-crypt-keypair --crypt-secretkey-file=0.key >/dev/null
dnscrypt-wrapper --gen-cert-file \
  --crypt-secretkey-file=0.key --provider-cert-file=0.crt \
  --provider-publickey-file=public.key \
  --provider-secretkey-file=secret.key --cert-file-expire-days=$expiry >/dev/null
dnscrypt-wrapper --no-tcp --resolver-address=127.0.0.1:53 \
  --listen-address=0.0.0.0:443 --provider-name=$name \
  --crypt-secretkey-file=0.key --provider-cert-file=0.crt -V


# https://github.com/drduh/config/blob/master/scripts/dnsmasq-dhcp.sh
touch /var/log/dnsmasq-dhcp
echo "$(date) -- ${1} ${2} ${3} ${4}" >> /var/log/dnsmasq-dhcp


# https://github.com/drduh/config/blob/master/scripts/iptables.sh
set -o errtrace
set -o nounset
set -o pipefail
PATH="/sbin"
EXT=enp1s0
INT=enp2s0
DMZ=enp3s0
LAB=enp4s0
WIFI=wlp5s0
#VIR=virbr0
INT_NET=172.16.1.0/24
DMZ_NET=10.8.1.0/24
LAB_NET=10.4.1.0/24
WIFI_NET=192.168.1.0/24
#VIR_NET=192.168.122.229/24
echo "Flushing rules"
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X
iptables -Z
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
echo "Allow loopback"
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
echo "Drop invalid states"
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A OUTPUT -m conntrack --ctstate INVALID -j DROP
iptables -A FORWARD -m conntrack --ctstate INVALID -j DROP
echo "Allow established and related connections"
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#echo "Allow ping replies"
#iptables -A INPUT -p icmp -m icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
echo "Allow DHCP"
iptables -I INPUT -i $INT -p udp -m udp --dport 67 -m conntrack --ctstate NEW -j ACCEPT
iptables -I INPUT -i $DMZ -p udp -m udp --dport 67 -m conntrack --ctstate NEW -j ACCEPT
iptables -I INPUT -i $LAB -p udp -m udp --dport 67 -m conntrack --ctstate NEW -j ACCEPT
iptables -I INPUT -i $WIFI -p udp -m udp --dport 67 -m conntrack --ctstate NEW -j ACCEPT
#iptables -I INPUT -i $VIR -p udp -m udp --dport 67 -m conntrack --ctstate NEW -j ACCEPT
#echo "Allow NTP"
#iptables -I INPUT -i $INT -p udp -m udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT
#iptables -I INPUT -i $DMZ -p udp -m udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT
#iptables -I INPUT -i $LAB -p udp -m udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT
#iptables -I INPUT -i $WIFI -p udp -m udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT
#echo "Allow iperf from local Ethernet"
#iptables -A INPUT -i $INT -s $INT_NET -p tcp --dport 5001 -m conntrack --ctstate NEW -j ACCEPT
echo "Allow SSH from local Ethernet"
iptables -A INPUT -i $INT -s $INT_NET -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
echo "Allow DNS (UDP and TCP for large replies)"
iptables -A INPUT -i $INT -s $INT_NET -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -i $INT -s $INT_NET -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -i $DMZ -s $DMZ_NET -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -i $DMZ -s $DMZ_NET -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -i $LAB -s $LAB_NET -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -i $LAB -s $LAB_NET -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -i $WIFI -s $WIFI_NET -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -i $WIFI -s $WIFI_NET -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
echo "Intercept HTTP traffic to Privoxy"
iptables -A INPUT -i $INT -s $INT_NET -p tcp --dport 8118 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -i $DMZ -s $DMZ_NET -p tcp --dport 8118 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -i $LAB -s $LAB_NET -p tcp --dport 8118 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -i $WIFI -s $WIFI_NET -p tcp --dport 8118 -m conntrack --ctstate NEW -j ACCEPT
iptables -t nat -A PREROUTING -i $INT -p tcp --dport 80 -j DNAT --to-destination 10.8.1.1:8118
iptables -t nat -A PREROUTING -i $DMZ -p tcp --dport 80 -j DNAT --to-destination 172.16.1.1:8118
iptables -t nat -A PREROUTING -i $LAB -p tcp --dport 80 -j DNAT --to-destination 10.4.1.1:8118
iptables -t nat -A PREROUTING -i $WIFI -p tcp --dport 80 -j DNAT --to-destination 192.168.1.1:8118
echo "Allow all outgoing"
iptables -A OUTPUT -o $EXT -p tcp -d 0.0.0.0/0 -j ACCEPT
iptables -A OUTPUT -o $EXT -p udp -d 0.0.0.0/0 -j ACCEPT
#iptables -A OUTPUT -o $EXT -p icmp -d 0.0.0.0/0 -j ACCEPT
#iptables -A OUTPUT -o $EXT -d 0.0.0.0/0 -j ACCEPT
#echo "Allow outgoing SSH"
#iptables -A OUTPUT -o $EXT -d 0.0.0.0/0 -p tcp --dport 22 -j ACCEPT
#echo "Allow outgoing DNS"
#iptables -A OUTPUT -o $EXT -d 1.1.1.1 -p udp --dport 53 -j ACCEPT
#echo "Allow outgoing HTTP"
#iptables -A OUTPUT -o $EXT -d 0.0.0.0/0 -p tcp --dport 80 -j ACCEPT
#echo "Allow outgoing HTTPS"
#iptables -A OUTPUT -o $EXT -d 0.0.0.0/0 -p tcp --dport 443 -j ACCEPT
#echo "Allow outgoing SMTP"
#iptables -A OUTPUT -o $EXT -d 0.0.0.0/0 -p tcp --dport 465 -j ACCEPT
#echo "Allow outgoing IMAP"
#iptables -A OUTPUT -o $EXT -d 0.0.0.0/0 -p tcp --dport 993 -j ACCEPT
#echo "Allow outgoing HKP"
#iptables -A OUTPUT -o $EXT -d 0.0.0.0/0 -p tcp --dport 11371 -j ACCEPT
#echo "Allow outgoing NTP"
#iptables -A OUTPUT -o $EXT -d 192.168.0.1 -p udp --dport 123 -j ACCEPT
#echo "Allow outgoing WHOIS lookups"
#iptables -A OUTPUT -o $EXT -p tcp --dport 43 -j ACCEPT
echo "Allow traffic from the firewall to local networks"
iptables -A OUTPUT -o $INT -d $INT_NET -j ACCEPT
iptables -A OUTPUT -o $DMZ -d $DMZ_NET -j ACCEPT
iptables -A OUTPUT -o $LAB -d $LAB_NET -j ACCEPT
iptables -A OUTPUT -o $WIFI -d $WIFI_NET -j ACCEPT
#iptables -A OUTPUT -o $VIR -d $VIR_NET -j ACCEPT
echo "Enable network address translation"
iptables -t nat -A POSTROUTING -o $EXT -j MASQUERADE
iptables -A FORWARD -o $EXT -i $INT -s $INT_NET -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -o $EXT -i $DMZ -s $DMZ_NET -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -o $EXT -i $LAB -s $LAB_NET -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -o $EXT -i $WIFI -s $WIFI_NET -m conntrack --ctstate NEW -j ACCEPT
#iptables -A FORWARD -o $EXT -i $VIR -s $VIR_NET -m conntrack --ctstate NEW -j ACCEPT
#iptables -t mangle -A POSTROUTING -j TTL --ttl-set 65
echo "Do not reply with Destination Unreachable messages"
iptables -A OUTPUT -p icmp --icmp-type destination-unreachable -j DROP
echo "Log all dropped packets"
iptables -A INPUT -m limit --limit 3/sec -j LOG --log-level debug --log-prefix "DROPIN>"
iptables -A OUTPUT -m limit --limit 3/sec -j LOG --log-level debug --log-prefix "DROPOUT>"
iptables -A FORWARD -m limit --limit 3/sec -j LOG --log-level debug --log-prefix "DROPFWD>"


# https://github.com/drduh/config/blob/master/scripts/pf-blocklist.sh
#
# Downloads IP addresses and ranges for blocking with PF:
#   1) Published lists of ad/malware hosts
#   2) Organizational Autonomous System (AS) assignments
#      (Requires https://github.com/drduh/config/tree/master/asns/*)
#   3) Country AS assignments
#      (Requires https://github.com/drduh/config/tree/master/zones)

#set -x

dns=1.1.1.1
custom=pf-custom.$(date +%F)
threats=pf-threats.$(date +%F)
zones=pf-zones.$(date +%F)
blocklist=pf-blocklist.$(date +%F)
doas whoami >/dev/null || exit 1

printf "Current rules: "
doas pfctl -t blocklist -T show | wc -l

action=""
while [[ -z "${action}" ]] ;
  do read -n 1 -p "Continue? (y/n) " action
done
printf "\n"

if [[ "${action}" =~ ^([yY])$ ]] ; then
  rm $custom $threats $zones $blocklist 2>/dev/null
  touch $custom $threats $zones

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

  # http://www.bgplookingglass.com/list-of-autonomous-system-numbers
  # https://github.com/drduh/config/tree/master/asns/*
  printf "Checking asns ..."
  for asn in $(find ../asns -type f) ; do
    printf "# $asn\n" >> $custom
    for nb in $(grep -v "^#" $asn) ; do
      printf " $nb"
      whois -h whois.radb.net !g$nb | tr " " "\n" | \
        grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]+" >> $custom
    done
  done
  wc -l $custom

  # https://www.abuseat.org/public/country.html
  # https://github.com/drduh/config/tree/master/zones
  printf "Checking zones ..."
  for zone in $(grep -v "^#" ../zones | sed "s/\ \ \#.*//g") ; do
    printf " $zone"
    curl -sq \
      "https://www.ipdeny.com/ipblocks/data/countries/$zone.zone" >> $zones
  done
  wc -l $zones

  sort $custom $threats $zones | uniq > $blocklist
  wc -l $blocklist

  if [[ ! -s $blocklist ]] ; then
    printf "Error: empty blocklist\n" ; exit 1
  fi

  doas cp -v /etc/pf/blocklist /etc/pf/blocklist.$(date +%F) && \
    doas cp -v ./$blocklist /etc/pf/blocklist
  doas pfctl -f /etc/pf.conf
  printf "\nnew rules: "
  doas pfctl -t blocklist -T show | wc -l

else
  printf "\ntesting blocked sites ...\n"
  for ws in $(/bin/ls ../asns) ; do
    printf "$ws.com: "
    curl -v \
      https://$(dig a $ws.com @$dns +short|head -n1) 2>&1 | \
        grep "Permission denied" || printf "BLOCK FAILED"
  done
fi


# Firefox
// https://github.com/drduh/config/blob/master/firefox.user.js
// https://github.com/ghacksuserjs/ghacks-user.js
// https://github.com/pyllyukko/user.js
//user_pref("browser.cache.disk.capacity", 0);  // disable disk cache
//user_pref("browser.cache.disk.enable", false);  // disable disk cache
//user_pref("browser.newtab.url", "about:blank");  // blank new tab page
//user_pref("browser.newtabpage.enabled", false);  // blank new tab page
//user_pref("browser.privatebrowsing.autostart", true);  // private browsing mode only; may break sites
//user_pref("browser.safebrowsing.malware.enabled", false);  // disable safebrowsing
//user_pref("browser.safebrowsing.phishing.enabled", false);  // disable safebrowsing
//user_pref("browser.search.widget.inNavBar", true); // move search bar to toolbar
//user_pref("browser.startup.homepage", "file:///home/web/index.html");  // custom start-up page
//user_pref("browser.startup.page", 1);  // 0: blank; 1: home; 2: last visited; 3: resume last
//user_pref("browser.uidensity", 1);  // reduce UI empty space
//user_pref("browser.urlbar.suggest.bookmark", false);  // do not suggest bookmarks
//user_pref("browser.urlbar.suggest.history", false);  // do not suggest history
//user_pref("dom.enable_performance", false);  // disable DOM timing; may break sites
//user_pref("dom.serviceWorkers.enabled", false);  // disable service workers; may break sites
//user_pref("dom.storage.enabled", false);  // disable DOM storage; will break sites
//user_pref("dom.storageManager.enabled", false);  // disable storage; may break sites
//user_pref("full-screen-api.enabled", false);  // disable fullscreen
//user_pref("gfx.xrender.enabled", true);  // may improve performance
//user_pref("javascript.enabled", false);  // disable javascript; will break sites
//user_pref("javascript.options.baselinejit", false);  // disable JS JIT; may break sites
//user_pref("javascript.options.ion", false);  // disable JS Ion; may break sites
//user_pref("layers.acceleration.disabled", true);  // disable hardware acceleration; performance hit
//user_pref("layers.acceleration.force-enabled", true);  // may improve performance on *nix
//user_pref("layout.css.devPixelsPerPx", "1.5");  // increase UI size
//user_pref("media.media-capabilities.enabled", false);  // disable media capabilities; may break sites
//user_pref("network.cookie.cookieBehavior", 1);  // block third-party cookies
//user_pref("network.cookie.lifetimePolicy", 2);  // expire cookies on browser close
//user_pref("network.dns.blockDotOnion", true);  // reject .onion domains
//user_pref("network.dns.disableIPv6", true);  // disable IPv6
//user_pref("network.http.referer.XOriginTrimmingPolicy", 2);  // limit Cross Origin path; may break sites
//user_pref("network.http.referer.defaultPolicy", 0);  // 0: no-ref; 1: same-origin; 2: strict-origin; 3: no-downgrade; may break sites
//user_pref("network.http.referer.defaultPolicy.pbmode", 0);
//user_pref("network.http.referer.trimmingPolicy", 2);  // trim Refer to scheme, host, port only; may break sites
//user_pref("network.http.sendRefererHeader", 0);  // send Referer; 0: never; 1: clicks; 2: links and images; may break sites
//user_pref("network.proxy.http", "127.0.0.1");  // proxy on localhost
//user_pref("network.proxy.http_port", 8118);  // privoxy on port 8118
//user_pref("network.proxy.no_proxies_on", "localhost, 127.0.0.1");
//user_pref("network.proxy.share_proxy_settings", true);
//user_pref("network.proxy.socks", "127.0.0.1");
//user_pref("network.proxy.socks_port", 5555);  // ssh tunnel on port 5555
//user_pref("network.proxy.socks_remote_dns", true);
//user_pref("network.proxy.ssl", "127.0.0.1");
//user_pref("network.proxy.ssl_port", 8118);  // privoxy on port 8118
//user_pref("network.proxy.type", 1);  // 1: manual; 2: PAC; 4: WPAD
//user_pref("privacy.clearOnShutdown.cookies", true);
//user_pref("privacy.clearOnShutdown.history", true);
//user_pref("privacy.cpd.cookies", true);
//user_pref("privacy.cpd.history", true);
//user_pref("privacy.donottrackheader.enabled", true);  // send DNT HTTP header
//user_pref("privacy.firstparty.isolate", true);  // isolate cookies to 1P; may break sites
//user_pref("privacy.resistFingerprinting", true);  // enable anti-fingerprinting features; may break sites
//user_pref("privacy.resistFingerprinting.letterboxing", true);  // letterbox window
//user_pref("privacy.sanitize.sanitizeOnShutdown", true);  // clear history on exit
//user_pref("privacy.trackingprotection.pbmode.enabled", false);
//user_pref("privacy.window.maxInnerHeight", 720);
//user_pref("privacy.window.maxInnerWidth", 1280);
//user_pref("security.OCSP.enabled", 1);  // enable OCSP fetching for all certs
//user_pref("security.OCSP.require", true);  // force check certificate revocation
//user_pref("security.dialog_enable_delay", 1000);  // ms delay on dialogs
//user_pref("security.ssl.require_safe_negotiation", true);  // may break sites
//user_pref("security.ssl3.rsa_aes_128_sha", false);  // disable cipher; may break sites
//user_pref("security.ssl3.rsa_aes_256_sha", false);  // disable cipher; may break sites
//user_pref("security.tls.version.min", 3);  // minimum TLS 1.2; may break sites
//user_pref("security.webauth.u2f", true);  // turn on U2F
//user_pref("svg.disabled", true);  // disable SVG rendering; may break sites
user_pref("accessibility.browsewithcaret", true);
user_pref("accessibility.force_disabled", 1);  // disable accessibility services
user_pref("accessibility.typeaheadfind", true);  // enable page search by typing
user_pref("accessibility.typeaheadfind.flashBar", 0);
user_pref("app.normandy.api_url", "");
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.first_run", false);
user_pref("app.shield.optoutstudies.enabled", false);  // disable studies
user_pref("app.update.auto", false);  // disable auto update check
user_pref("app.update.service.enabled", false);
user_pref("app.update.silent", false);  // notify on all updates states
user_pref("app.update.staging.enabled", false);  // do not stage background updates
user_pref("app.update.url", "");
user_pref("beacon.enabled", false);  // disable additional analytics
user_pref("breakpad.reportURL", "");  // disable crash reports
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.aboutHomeSnippets.updateUrl", "");
user_pref("browser.bookmarks.max_backups", 0);
user_pref("browser.bookmarks.restore_default_bookmarks", false);
user_pref("browser.cache.disk.smart_size.enabled", false);
user_pref("browser.cache.disk.smart_size.first_run", false);
user_pref("browser.cache.disk.smart_size.use_old_max", false);
user_pref("browser.cache.disk_cache_ssl", false);  // disable caching SSL pages
user_pref("browser.cache.offline.enable", false);  // disable offline cache
user_pref("browser.cache.offline.insecure.enable", false);
user_pref("browser.casting.enabled", false);  // disable SSDP
user_pref("browser.chrome.errorReporter.enabled", false);  // disable browser error reporter
user_pref("browser.chrome.errorReporter.submitUrl", "");
user_pref("browser.contentHandlers.types.0.uri", "");
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);
user_pref("browser.ctrlTab.recentlyUsedOrder", false);  // control-tab cycles tabs
user_pref("browser.dictionaries.download.url", "");
user_pref("browser.disableResetPrompt", true);
user_pref("browser.discovery.enabled", false);  // disable extension recommendations
user_pref("browser.display.use_document_fonts", 0);  // disable web pages picking fonts
user_pref("browser.download.autohideButton", false);
user_pref("browser.download.forbid_open_with", true);  // disable Open With dialog
user_pref("browser.download.hide_plugins_without_extensions", false);
user_pref("browser.download.manager.addToRecentDocs", false);  // disable adding recent documents
user_pref("browser.download.manager.retention", 0);  // disable download history
user_pref("browser.download.useDownloadDir", false);
user_pref("browser.fixup.alternate.enabled", false);  // disable invalid name assistance
user_pref("browser.fixup.hide_user_pass", true);
user_pref("browser.formfill.enable", false);  // disable auto-completion
user_pref("browser.geolocation.warning.infoURL", "");
user_pref("browser.helperApps.deleteTempFileOnExit", true);
user_pref("browser.library.activity-stream.enabled", false);
user_pref("browser.link.open_newwindow", 3);  // open new windows in tabs instead
user_pref("browser.link.open_newwindow.restriction", 0);
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);
user_pref("browser.newtab.preload", false);  // disable new tab tile preload
user_pref("browser.newtabpage.activity-stream.asrouter.providers.snippets", "");  // disable activity stream snippets
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr", false);  // disable extension recommendations
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.newtabpage.activity-stream.disableSnippets", true);
user_pref("browser.newtabpage.activity-stream.discoverystream.optOut.0", true);
user_pref("browser.newtabpage.activity-stream.enabled", false);
user_pref("browser.newtabpage.activity-stream.feed.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.asrouterfeed", false);  // disable activity stream feed
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);  // disable snippets
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.prerender", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry.ping.endpoint", "");
user_pref("browser.newtabpage.activity-stream.tippyTop.service.endpoint", "");
user_pref("browser.newtabpage.enhanced", false);
user_pref("browser.newtabpage.remote", false);
user_pref("browser.newtabpage.storageVersion", 1);
user_pref("browser.offline-apps.notify", true);  // notify on offline app storage
user_pref("browser.onboarding.enabled", false);  // disable new profile tour
user_pref("browser.pagethumbnails.capturing_disabled", true);
user_pref("browser.pagethumbnails.storage_version", 3);
user_pref("browser.ping-centre.production.endpoint", "");
user_pref("browser.ping-centre.staging.endpoint", "");
user_pref("browser.ping-centre.telemetry", false);  // disable PingCentre telemetry
user_pref("browser.safebrowsing.appRepURL", "");
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.url", "");
user_pref("browser.safebrowsing.provider.google.reportMalwareMistakeURL", "");
user_pref("browser.safebrowsing.provider.google.reportPhishMistakeURL", "");
user_pref("browser.safebrowsing.provider.google.reportURL", "");
user_pref("browser.safebrowsing.provider.google4.dataSharing.enabled", false);  // disable safebrowsing data sharing
user_pref("browser.safebrowsing.provider.google4.dataSharingURL", "");
user_pref("browser.safebrowsing.provider.google4.reportMalwareMistakeURL", "");
user_pref("browser.safebrowsing.provider.google4.reportPhishMistakeURL", "");
user_pref("browser.safebrowsing.provider.google4.reportURL", "");
user_pref("browser.search.countryCode", "US");
user_pref("browser.search.geoSpecificDefaults", false);
user_pref("browser.search.geoSpecificDefaults.url", "");
user_pref("browser.search.geoip.url", "");  // disable geo-IP assisted search
user_pref("browser.search.hiddenOneOffs", "Bing,Amazon.com,eBay,Twitter");  // disable search providers
user_pref("browser.search.region", "US");
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.search.update", false);
user_pref("browser.search.widget.inNavBar", true);
user_pref("browser.selfsupport.url", "");  // disable user rating telemetry
user_pref("browser.send_pings", false);  // disable ping attributes
user_pref("browser.send_pings.require_same_host", true);
user_pref("browser.sessionhistory.max_entries", 10);  // limit session history
user_pref("browser.sessionstore.interval", 30000);
user_pref("browser.sessionstore.max_tabs_undo", 0);  // disable recently closed tabs
user_pref("browser.sessionstore.max_windows_undo", 0);
user_pref("browser.sessionstore.privacy_level", 2);  // disable session restore
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("browser.shell.checkDefaultBrowser", false);  // disable default check
user_pref("browser.shell.shortcutFavicons", false);  // disable shortcuts favicons
user_pref("browser.ssl_override_behavior", 1);
user_pref("browser.startup.homepage_override.buildID", "20100101");
user_pref("browser.startup.homepage_override.mstone", "ignore");  // disable welcome pages
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.tabs.remote.allowLinkedWebInFileUriProcess", false);
user_pref("browser.tabs.remote.autostart.2", true);
user_pref("browser.tabs.warnOnClose", false);  // close without warning
user_pref("browser.tabs.warnOnCloseOtherTabs", false);
user_pref("browser.tabs.warnOnOpen", false);
user_pref("browser.uitour.enabled", false);  // disable UI tour
user_pref("browser.uitour.url", "");
user_pref("browser.urlbar.autoFill", false);
user_pref("browser.urlbar.autoFill.typed", false);
user_pref("browser.urlbar.autocomplete.enabled", false);
user_pref("browser.urlbar.filter.javascript", true);  // hide JS in history
user_pref("browser.urlbar.maxHistoricalSearchSuggestions", 0);  // disable local search history
user_pref("browser.urlbar.oneOffSearches", false);
user_pref("browser.urlbar.placeholderName", "DuckDuckGo");
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);  // disable suggestions
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);  // disable sponsored suggestions
user_pref("browser.urlbar.searchSuggestionsChoice", false);
user_pref("browser.urlbar.speculativeConnect.enabled", false);  // disable preloading auto-complete URLs
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.trimURLs", false);  // disable trim HTTP off of URLs
user_pref("browser.urlbar.usepreloadedtopurls.enabled", false);  // disable pre-loaded URLs
user_pref("browser.urlbar.userMadeSearchSuggestionsChoice", true);
user_pref("browser.xul.error_pages.expert_bad_cert", true);
user_pref("camera.control.face_detection.enabled", false);  // disable webcam face detection
user_pref("canvas.capturestream.enabled", false);  // disable canvas capture stream
user_pref("captivedetect.canonicalURL", "");  // disable captive portal helper
user_pref("clipboard.autocopy", false);  // disable automatic clipboard selection
user_pref("datareporting.healthreport.infoURL", "");
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.service.firstRun", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("device.sensors.enabled", false);  // disable device sensors
user_pref("devtools.chrome.enabled", false);  // disable tools in browser context
user_pref("devtools.debugger.force-local", true);  // disable remote debugging
user_pref("devtools.debugger.remote-enabled", false);
user_pref("devtools.devedition.promo.url", "");
user_pref("devtools.onboarding.telemetry.logged", true);
user_pref("devtools.screenshot.audio.enabled", false);
user_pref("devtools.theme", "dark");
user_pref("devtools.webide.autoinstallADBHelper", false);
user_pref("devtools.webide.autoinstallFxdtAdapters", false);
user_pref("devtools.webide.enabled", false);  // disable WebIDE
user_pref("devtools.webide.simulatorAddonsURL", "");
user_pref("dom.IntersectionObserver.enabled", false);  // disable Intersection Observer
user_pref("dom.allow_cut_copy", false);  // disable copy-to-clipboard js functionality
user_pref("dom.battery.enabled", false);  // disable battery status
user_pref("dom.caches.enabled", false);  // disable service workers cache
user_pref("dom.disable_beforeunload", true);  // disable page leave warning
user_pref("dom.disable_open_during_load", true);  // block popups
user_pref("dom.disable_window_move_resize", true);
user_pref("dom.disable_window_open_feature.close", true);  // disable web pages from removing window features
user_pref("dom.disable_window_open_feature.location", true);
user_pref("dom.disable_window_open_feature.menubar", true);
user_pref("dom.disable_window_open_feature.minimizable", true);
user_pref("dom.disable_window_open_feature.personalbar", true);
user_pref("dom.disable_window_open_feature.resizable", true);
user_pref("dom.disable_window_open_feature.status", true);
user_pref("dom.disable_window_open_feature.titlebar", true);
user_pref("dom.disable_window_open_feature.toolbar", true);
user_pref("dom.enable_resource_timing", false);  // disable resource timing
user_pref("dom.event.clipboardevents.enabled", false);  // disable notify on clipboard events
user_pref("dom.event.contextmenu.enabled", false);  // disable web page control over right-click context
user_pref("dom.event.highrestimestamp.enabled", true);  // enable DOMHighResTimeStamp
user_pref("dom.flyweb.enabled", false);  // disable local discovery
user_pref("dom.forms.autocomplete.formautofill", true);
user_pref("dom.forms.datetime", false);
user_pref("dom.gamepad.enabled", false);  // disable USB enumeration
user_pref("dom.imagecapture.enabled", false);  // disable camera image capture
user_pref("dom.ipc.plugins.flash.subprocess.crashreporter.enabled", false);
user_pref("dom.ipc.plugins.reportCrashURL", false);
user_pref("dom.mozTCPSocket.enabled", false);  // disable raw tcp sockets
user_pref("dom.netinfo.enabled", false);  // disable network information api
user_pref("dom.network.enabled", false);  // disable network information api
user_pref("dom.popup_allowed_events", "click dblclick");  // limit popup-triggering events
user_pref("dom.popup_maximum", 2);  // maximum of 2 popups from a single event
user_pref("dom.push.connection.enabled", false);  // disable push notifications
user_pref("dom.push.enabled", false);
user_pref("dom.push.serverURL", "");
user_pref("dom.push.userAgentID", "");
user_pref("dom.telephony.enabled", false);  // disable telephony API
user_pref("dom.vibrator.enabled", false);  // disable screen shake
user_pref("dom.vr.enabled", false);  // disable VR devices
user_pref("dom.w3c_pointer_events.enabled", false);  // disable PointerEvents
user_pref("dom.w3c_touch_events.enabled", 0);  // disable touch events
user_pref("dom.webaudio.enabled", false);  // disable web audio
user_pref("dom.webnotifications.enabled", false);  // disable web notifications
user_pref("dom.webnotifications.serviceworker.enabled", false);  // disable web notifications
user_pref("experiments.activeExperiment", false);
user_pref("experiments.enabled", false);
user_pref("experiments.manifest.uri", "");
user_pref("experiments.supported", false);
user_pref("extensions.autoDisableScopes", 15);
user_pref("extensions.blocklist.enabled", false);  // disable extension blacklisting
user_pref("extensions.blocklist.pingCountTotal", 4);
user_pref("extensions.blocklist.pingCountVersion", 0);
user_pref("extensions.blocklist.url", "https://blocklists.settings.services.mozilla.com/v1/blocklist/3/%20/%20/");
user_pref("extensions.enabledScopes", 1);  // lock down allowed extension directories
user_pref("extensions.formautofill.addresses.enabled", false);  // disable form auto-fill
user_pref("extensions.formautofill.available", "off");
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.formautofill.heuristics.enabled", false);
user_pref("extensions.fxmonitor.enabled", false);  // disable Monitor
user_pref("extensions.getAddons.cache.enabled", false);  // disable add-on metadata updates
user_pref("extensions.getAddons.databaseSchema", 5);
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.pocket.enabled", false);  // disable Pocket
user_pref("extensions.screenshots.disabled", true);  // disable Screenshots
user_pref("extensions.screenshots.system-disabled", true);
user_pref("extensions.screenshots.upload-disabled", true);
user_pref("extensions.shield-recipe-client.api_url", "");
user_pref("extensions.shield-recipe-client.enabled", false);
user_pref("extensions.systemAddon.update.enabled", false);  // disable system addon updates
user_pref("extensions.systemAddon.update.url", "");
user_pref("extensions.ui.dictionary.hidden", true);
user_pref("extensions.ui.experiment.hidden", true);
user_pref("extensions.ui.locale.hidden", true);
user_pref("extensions.update.autoUpdateDefault", false);
user_pref("extensions.webcompat-reporter.enabled", false);  // disable web compatibility reporter
user_pref("extensions.webservice.discoverURL", "");
user_pref("font.blacklist.underline_offset", "");  // disable special underline handling
user_pref("gecko.handlerService.migrated", true);
user_pref("gecko.handlerService.schemes.webcal.0.uriTemplate", "");
user_pref("general.buildID.override", "20100101");
user_pref("general.warnOnAboutConfig", false);  // disable about:config warning
user_pref("geo.enabled", false);  // no geo-location
user_pref("geo.provider.ms-windows-location", false);  // disable geo on windows
user_pref("geo.provider.use_corelocation", false);  // disable geo on mac
user_pref("geo.provider.use_gpsd", false);  // disable geo on linux
user_pref("geo.wifi.logging.enabled", false);
user_pref("geo.wifi.uri", "");
user_pref("gfx.downloadable_fonts.woff2.enabled", false);
user_pref("gfx.font_rendering.graphite.enabled", false);
user_pref("gfx.font_rendering.opentype_svg.enabled", false);
user_pref("gfx.offscreencanvas.enabled", false);  // disable offscreen canvas
user_pref("identity.fxaccounts.enabled", false);  // disable Firefox accounts sync
user_pref("intl.accept_languages", "en-US, en");
user_pref("intl.charset.fallback.override", "utf-8");
user_pref("intl.locale.requested", "en-US");
user_pref("intl.regional_prefs.use_os_locales", false);  // don't use OS to determine locale
user_pref("javascript.options.asmjs", false);
user_pref("javascript.options.shared_memory", false);  // disable shared memory
user_pref("javascript.options.wasm", false);  // disable webassembly
user_pref("javascript.use_us_english_locale", true);
user_pref("keyword.enabled", false);  // do not submit invalid URLs to search engine
user_pref("layout.css.font-loading-api.enabled", false);
user_pref("layout.css.visited_links_enabled", false);  // disable CSS page history
user_pref("layout.spellcheckDefault", 2);  // spell-check; 0: none; 1: multi-line; 2: multi- and single-line
user_pref("lightweightThemes.persisted.footerURL", false);
user_pref("lightweightThemes.persisted.headerURL", false);
user_pref("lightweightThemes.update.enabled", false);  // disable themes auto updates
user_pref("loop.logDomains", false);  // disable more telemetry
user_pref("mathml.disabled", true);  // disable Mathematical Markup Language
user_pref("media.autoplay.default", 2);  // HTML5 media - 0: allow; 1: block; 2: prompt
user_pref("media.autoplay.default", 5);
user_pref("media.block-autoplay-until-in-foreground", true);  // disable auto-play in background tabs
user_pref("media.eme.apiVisible", false);  // disable DRM profiling
user_pref("media.eme.enabled", false);  // disable DRM HTML5 content
user_pref("media.getusermedia.audiocapture.enabled", false);  // disable audio capture
user_pref("media.getusermedia.browser.enabled", false);  // disable WebRTC getUserMedia
user_pref("media.getusermedia.screensharing.enabled", false);  // disable screen-sharing
user_pref("media.gmp-gmpopenh264.autoupdate", false);  // disable OpenH264 codec by Cisco
user_pref("media.gmp-gmpopenh264.enabled", false);
user_pref("media.gmp-manager.updateEnabled", false);
user_pref("media.gmp-manager.url", "data:text/plain,");
user_pref("media.gmp-manager.url.override", "data:text/plain,");
user_pref("media.gmp-provider.enabled", false);
user_pref("media.gmp-widevinecdm.autoupdate", false);
user_pref("media.gmp-widevinecdm.enabled", false);  // disable DRM HTML5 content
user_pref("media.gmp-widevinecdm.visible", false);
user_pref("media.gmp.storage.version.observed", 1);
user_pref("media.gmp.trial-create.enabled", false);
user_pref("media.navigator.enabled", false);  // disable media device enumeration
user_pref("media.navigator.video.enabled", false);
user_pref("media.ondevicechange.enabled", false);  // disable media devices change detection
user_pref("media.peerconnection.enabled", false);
user_pref("media.peerconnection.ice.default_address_only", true);
user_pref("media.peerconnection.ice.no_host", true);
user_pref("media.peerconnection.ice.proxy_only", true);
user_pref("media.peerconnection.ice.tcp", false);
user_pref("media.peerconnection.identity.enabled", false);
user_pref("media.peerconnection.identity.timeout", 1);
user_pref("media.peerconnection.turn.disable", true);
user_pref("media.peerconnection.use_document_iceservers", false);
user_pref("media.peerconnection.video.enabled", false);
user_pref("media.video_stats.enabled", false);  // disable video statistics
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);
user_pref("media.webspeech.recognition.enable", false);  // disable speech recognition
user_pref("media.webspeech.synth.enabled", false);  // disable speech synthesis
user_pref("middlemouse.contentLoadURL", false);  // disable open URLs from clibpard with middle click
user_pref("network.IDN_show_punycode", true);  // reduce phishing risk
user_pref("network.allow-experiments", false);  // disable experiments
user_pref("network.auth.subresource-http-auth-allow", 1);  // disable non-secure authentication
user_pref("network.captive-portal-service.enabled", false);  // disable captive portal helper
user_pref("network.connectivity-service.enabled", false);  // disable network connectivity checks
user_pref("network.connectivity-service.enabled", false);  // don't help with captive portals
user_pref("network.cookie.leave-secure-alone", true);  // disable non-secure sites setting secure cookies
user_pref("network.cookie.thirdparty.nonsecureSessionOnly", true);
user_pref("network.cookie.thirdparty.sessionOnly", true);
user_pref("network.dns.disablePrefetch", true);  // disable DNS prefetch
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("network.file.disable_unc_paths", true);  // disable Uniform Naming Convention paths
user_pref("network.ftp.enabled", false);  // disable FTP
user_pref("network.gio.supported-protocols", "");  // disable Gvfs/GIO
user_pref("network.http.altsvc.enabled", false);  // disable HTTP Alternative Services
user_pref("network.http.altsvc.oe", false);
user_pref("network.http.redirection-limit", 5);  // limit HTTP redirects
user_pref("network.http.referer.XOriginPolicy", 1);  // only send Referer to same domain
user_pref("network.http.referer.hideOnionSource", true);
user_pref("network.http.spdy.enabled", false);  // disable HTTP2
user_pref("network.http.spdy.enabled.deps", false);
user_pref("network.http.spdy.enabled.http2", false);
user_pref("network.http.spdy.websockets", false);
user_pref("network.http.speculative-parallel-limit", 0);  // disable speculative loading
user_pref("network.jar.open-unsafe-types", false);
user_pref("network.manage-offline-status", false);  // do not monitor OS connection state
user_pref("network.negotiate-auth.allow-insecure-ntlm-v1", false);  // disable NTLMv1
user_pref("network.negotiate-auth.allow-insecure-ntlm-v1-https", false);  // disable all NTLM
user_pref("network.predictor.cleaned-up", true);
user_pref("network.predictor.enable-prefetch", false);  // disable prefetching
user_pref("network.predictor.enabled", false);  // disable "Necko" predictive service
user_pref("network.prefetch-next", false);  // disable prefetching
user_pref("network.protocol-handler.expose-all", false);  // whitelist URL handlers
user_pref("network.protocol-handler.expose.about", true);
user_pref("network.protocol-handler.expose.blob", true);
user_pref("network.protocol-handler.expose.chrome", true);
user_pref("network.protocol-handler.expose.data", true);
user_pref("network.protocol-handler.expose.file", true);
user_pref("network.protocol-handler.expose.ftp", true);
user_pref("network.protocol-handler.expose.http", true);
user_pref("network.protocol-handler.expose.https", true);
user_pref("network.protocol-handler.expose.javascript", true);
user_pref("network.protocol-handler.expose.moz-extension", true);
user_pref("network.protocol-handler.external.about", false);
user_pref("network.protocol-handler.external.blob", false);
user_pref("network.protocol-handler.external.chrome", false);
user_pref("network.protocol-handler.external.data", false);
user_pref("network.protocol-handler.external.file", false);
user_pref("network.protocol-handler.external.ftp", false);
user_pref("network.protocol-handler.external.http", false);
user_pref("network.protocol-handler.external.https", false);
user_pref("network.protocol-handler.external.javascript", false);
user_pref("network.protocol-handler.external.moz-extension", false);
user_pref("network.protocol-handler.external.ms-windows-store", false);
user_pref("network.protocol-handler.warn-external-default", true);
user_pref("network.stricttransportsecurity.preloadlist", true);  // preload HSTS
user_pref("network.trr.bootstrapAddress", "");
user_pref("network.trr.mode", 0);  // disable trusted recursive resolver
user_pref("network.trr.uri", "");
user_pref("offline-apps.allow_by_default", false);
user_pref("pdfjs.disabled", true);  // disable PDF viewer
user_pref("pdfjs.enableWebGL", false);
user_pref("pdfjs.migrationVersion", 2);
user_pref("pdfjs.previousHandler.alwaysAskBeforeHandling", true);
user_pref("pdfjs.previousHandler.preferredAction", 4);
user_pref("permissions.default.camera", 2);
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.geo", 2);
user_pref("permissions.default.microphone", 2);
user_pref("permissions.default.shortcuts", 2);
user_pref("permissions.default.xr", 2);
user_pref("permissions.manager.defaultsUrl", "");
user_pref("permissions.memory_only", true);  // disable storing permission changes to disk
user_pref("plugin.default.state", 0);
user_pref("plugin.defaultXpi.state", 0);
user_pref("plugin.disable_full_page_plugin_for_types", "application/pdf");
user_pref("plugin.scan.plid.all", false);  // disable plugin scan
user_pref("plugin.sessionPermissionNow.intervalInMinutes", 0);  // always ask for activation
user_pref("plugin.state.flash", 0);  // disable flash
user_pref("plugin.state.java", 0);  // disable java
user_pref("plugin.state.libgnome-shell-browser-plugin", 0);  // disable gnome shell integration
user_pref("plugins.click_to_play", true);  // require plugin activation
user_pref("pref.browser.homepage.disable_button.current_page", false);
user_pref("pref.privacy.disable_button.cookie_exceptions", false);
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.openWindows", true);
user_pref("privacy.clearOnShutdown.sessions", true);
user_pref("privacy.clearOnShutdown.siteSettings", true);
user_pref("privacy.cpd.cache", true);
user_pref("privacy.cpd.downloads", true);
user_pref("privacy.cpd.formdata", true);
user_pref("privacy.cpd.offlineApps", true);
user_pref("privacy.cpd.sessions", true);
user_pref("privacy.history.custom", true);
user_pref("privacy.resistFingerprinting.block_mozAddonManager", true);  // disable mozAddonManager
user_pref("privacy.sanitize.pending", "[]");
user_pref("privacy.sanitize.timeSpan", 0);  // set default clear history range to all time
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);  // https://wiki.mozilla.org/Security/Tracking_protection
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.introCount", 20);
user_pref("privacy.trackingprotection.ui.enabled", true);
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.longPressBehavior", 2);  // long-press on + tab button to open container menu
user_pref("privacy.userContext.ui.enabled", true);  // enable container tabs setting
user_pref("privacy.usercontext.about_newtab_segregation.enabled", true);
user_pref("security.cert_pinning.enforcement_level", 2);  // strict pinning enforcement
user_pref("security.csp.enable", true);  // enforce Content Security Policy
user_pref("security.csp.experimentalEnabled", true);  // enable experimental CSP features
user_pref("security.data_uri.block_toplevel_data_uri_navigations", true);
user_pref("security.fileuri.strict_origin_policy", true);
user_pref("security.insecure_connection_icon.enabled", true);
user_pref("security.insecure_connection_text.enabled", true);
user_pref("security.insecure_field_warning.contextual.enabled", true);
user_pref("security.insecure_password.ui.enabled", true);  // warn on non-secure forms
user_pref("security.mixed_content.block_active_content", true);  // disable insecure content on HTTPS pages
user_pref("security.mixed_content.block_display_content", true);
user_pref("security.mixed_content.block_object_subrequest", true);
user_pref("security.pki.sha1_enforcement_level", 1);  // block SHA1 certs
user_pref("security.sri.enable", true);  // enable Subresource Integrity
user_pref("security.ssl.disable_session_identifiers", true);  // disable SSL Session IDs
user_pref("security.ssl.enable_ocsp_must_staple", true);
user_pref("security.ssl.enable_ocsp_stapling", true);
user_pref("security.ssl.errorReporting.automatic", false);  // do not report TLS errors
user_pref("security.ssl.errorReporting.enabled", false);
user_pref("security.ssl.errorReporting.url", "");
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("security.ssl3.dhe_dss_aes_128_sha", false);
user_pref("security.ssl3.dhe_dss_aes_256_sha", false);
user_pref("security.ssl3.dhe_dss_camellia_128_sha", false);
user_pref("security.ssl3.dhe_dss_camellia_256_sha", false);
user_pref("security.ssl3.dhe_dss_des_ede3_sha", false);
user_pref("security.ssl3.dhe_rsa_aes_128_sha", false);
user_pref("security.ssl3.dhe_rsa_aes_256_sha", false);
user_pref("security.ssl3.dhe_rsa_camellia_128_sha", false);
user_pref("security.ssl3.dhe_rsa_camellia_256_sha", false);
user_pref("security.ssl3.dhe_rsa_des_ede3_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_aes_128_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_aes_256_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_des_ede3_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_null_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_rc4_128_sha", false);
user_pref("security.ssl3.ecdh_rsa_aes_128_sha", false);
user_pref("security.ssl3.ecdh_rsa_aes_256_sha", false);
user_pref("security.ssl3.ecdh_rsa_des_ede3_sha", false);
user_pref("security.ssl3.ecdh_rsa_null_sha", false);
user_pref("security.ssl3.ecdh_rsa_rc4_128_sha", false);
user_pref("security.ssl3.ecdhe_ecdsa_aes_128_gcm_sha256", true);
user_pref("security.ssl3.ecdhe_ecdsa_aes_128_sha", false);
user_pref("security.ssl3.ecdhe_ecdsa_aes_256_sha", true);
user_pref("security.ssl3.ecdhe_ecdsa_chacha20_poly1305_sha256", true);
user_pref("security.ssl3.ecdhe_ecdsa_des_ede3_sha", false);
user_pref("security.ssl3.ecdhe_ecdsa_null_sha", false);
user_pref("security.ssl3.ecdhe_ecdsa_rc4_128_sha", false);
user_pref("security.ssl3.ecdhe_rsa_aes_128_gcm_sha256", true);
user_pref("security.ssl3.ecdhe_rsa_aes_128_sha", false);
user_pref("security.ssl3.ecdhe_rsa_aes_256_sha", true);
user_pref("security.ssl3.ecdhe_rsa_chacha20_poly1305_sha256", true);
user_pref("security.ssl3.ecdhe_rsa_des_ede3_sha", false);
user_pref("security.ssl3.ecdhe_rsa_null_sha", false);
user_pref("security.ssl3.ecdhe_rsa_rc4_128_sha", false);
user_pref("security.ssl3.rsa_1024_rc4_56_sha", false);
user_pref("security.ssl3.rsa_camellia_128_sha", false);
user_pref("security.ssl3.rsa_camellia_256_sha", false);
user_pref("security.ssl3.rsa_des_ede3_sha", false);
user_pref("security.ssl3.rsa_fips_des_ede3_sha", false);
user_pref("security.ssl3.rsa_null_md5", false);
user_pref("security.ssl3.rsa_null_sha", false);
user_pref("security.ssl3.rsa_rc2_40_md5", false);
user_pref("security.ssl3.rsa_rc4_128_md5", false);
user_pref("security.ssl3.rsa_rc4_128_sha", false);
user_pref("security.ssl3.rsa_rc4_40_md5", false);
user_pref("security.ssl3.rsa_seed_sha", false);
user_pref("security.tls.enable_0rtt_data", false);  // disable TLS1.3 0-RTT
user_pref("security.tls.version.fallback-limit", 3);  // disable insecure fallback
user_pref("security.xpconnect.plugin.unrestricted", false);  // disable scripting of plugins by javascript
user_pref("services.blocklist.update_enabled", true);
user_pref("services.sync.clients.lastSync", "0");
user_pref("services.sync.declinedEngines", "");
user_pref("services.sync.globalScore", 0);
user_pref("services.sync.nextSync", 0);
user_pref("services.sync.tabs.lastSync", "0");
user_pref("shield.savant.enabled", false);
user_pref("shumway.disabled", true);  // disable Mozilla Flash
user_pref("signon.autofillForms", false);
user_pref("signon.autofillForms.http", false);
user_pref("signon.formlessCapture.enabled", false);
user_pref("signon.rememberSignons", false);  // disable saving passwords
user_pref("startup.homepage_override_url", "");
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("toolkit.cosmeticAnimations.enabled", false);  // disable animations
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("toolkit.coverage.opt-out", true);  // disable telemetry coverage
user_pref("toolkit.crashreporter.infoURL", "");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.cachedClientID", "");
user_pref("toolkit.telemetry.coverage.opt-out", true);  // disable telemetry coverage
user_pref("toolkit.telemetry.enabled", false);  // disable Mozilla telemetry
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.hybridContent.enabled", false);
user_pref("toolkit.telemetry.infoURL", "");
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.previousBuildID", "");
user_pref("toolkit.telemetry.prompted", 2);
user_pref("toolkit.telemetry.rejected", true);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.unified", false);  // disable telemetry
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.winRegisterApplicationRestart", false);  // disable session restore
user_pref("ui.key.menuAccessKey", 0);  // disable Alt key for menu
user_pref("ui.use_standins_for_native_colors", true);  // disable exposing system colors to canvas
user_pref("webchannel.allowObject.urlWhitelist", "");
user_pref("webgl.disable-extensions", true);  // disable Web Graphics Library
user_pref("webgl.disable-fail-if-major-performance-caveat", true);
user_pref("webgl.disabled", true);  // disable WebGL
user_pref("webgl.dxgl.enabled", false);
user_pref("webgl.enable-debug-renderer-info", false);  // do not expose graphics driver information
user_pref("webgl.enable-webgl2", false);
user_pref("webgl.min_capability_mode", true);
user_pref("xpinstall.signatures.required", true);  // extensions must be signed