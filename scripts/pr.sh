

sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false
sudo networksetup -setwebproxy "Wi-Fi" 127.0.0.1 8118
sudo networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 8118
defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool YES

sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
sudo rm -rfv "~/Library/Logs/*" "/var/log/*" "~/Library/Caches/*" "/Library/Caches/*" "~/Library/Saved Application State/*"
netstat -anv | grep CLOSE_WAIT | awk '{print $9}' | xargs kill && netstat -anv | grep CLOSED | awk '{print $9}' | xargs kill
sudo chmod -R 000 ~/Library/LanguageModeling ~/Library/Spelling ~/Library/Suggestions
sudo chflags -R uchg ~/Library/LanguageModeling ~/Library/Spelling ~/Library/Suggestions
sudo chmod -R 000 "~/Library/Application Support/Quick Look"
sudo chflags -R uchg "~/Library/Application Support/Quick Look"
sudo chflags -R uchg ~/Library/Assistant/SiriAnalytics.db
defaults delete ~/Library/Preferences/com.apple.iTunes.plist recentSearches
defaults delete ~/Library/Preferences/com.apple.iTunes.plist StoreUserInfo
defaults delete ~/Library/Preferences/com.apple.iTunes.plist WirelessBuddyID

rm -rfv "~/Library/LanguageModeling/*" "~/Library/Spelling/*" "~/Library/Suggestions/*" && rm -rfv "~/Library/Application Support/Quick Look/*" && rm -rfv ~/Library/Assistant/SiriAnalytics.db
rm -rf ~/Library/Containers/com.apple.QuickTimePlayerX/Data/Library/Preferences/com.apple.QuickTimePlayerX.plist && rm -rf ~/Library/Containers/com.apple.appstore/Data/Library/Preferences/com.apple.commerce.knownclients.plist && rm -rf ~/Library/Preferences/com.apple.commerce.plist && rm -rf ~/Library/Preferences/com.apple.QuickTimePlayerX.plist

sudo rm -rfv /var/spool/cups/c0*
sudo rm -rfv /var/spool/cups/tmp/*
sudo rm -rfv /var/spool/cups/cache/job.cache*
sudo rm -rfv /var/db/lockdown/*

defaults delete ~/Library/Preferences/com.apple.finder.plist FXDesktopVolumePositions
defaults delete ~/Library/Preferences/com.apple.finder.plist FXRecentFolders
defaults delete ~/Library/Preferences/com.apple.finder.plist RecentMoveAndCopyDestinations
defaults delete ~/Library/Preferences/com.apple.finder.plist RecentSearches
defaults delete ~/Library/Preferences/com.apple.finder.plist SGTRecentFileSearches



### DATA SCIENCE AND MACHINE LEARNING ###
PYTHON_VERSION=$(cat .python-version)
brew install miniforge
conda create -n base_env python=$PYTHON_VERSION
conda install seaborn
conda install -c conda-forge cookiecutter

### INSTALLING TENSOR FLOW ###
conda install -c apple tensorflow-deps
conda config --prepend channels apple


### PIP ENV ###
pipenv --python $PYTHON_VERSION


### GIT ###
git config --global user.name "johnpatrickroach"
git config --global user.email "johnpatrickroach1@gmail.com"
git config --global commit.gpgsign true
git config --global user.signingkey {YOUR_GPG_KEY_FINGERPRINT}


### COOKIE CUTTER DATA SCIENCE ###'
conda create -n my-project-env pandas jupyter scikit-learn matplotlib seaborn
conda activate my-project-env
cookiecutter -c v1 https://github.com/drivendata/cookiecutter-data-science
code my-project-directory
git init
git add .
git commit -m "First commit."
git remote add origin https://www.github.com/yourname/your-repo-name.git
git push origin master


### SOFTARE UPDATE ###
softwareupdate -i -a


### GITHUB ###
gh auth login



### R ###
Sys.setlocale(category="LC_ALL", locale = "en_US.UTF-8")


### asdf ###
asdf plugin-add erlang
asdf plugin-add elixir
asdf plugin-add nodejs
asdf plugin-add yarn
asdf plugin-add direnv

asdf install erlang latest
asdf install elixir latest
asdf install nodejs latest
asdf install yarn latest
asdf install direnv latest
direnv_version=$(direnv --version)
asdf global direnv ${direnv_version}


### postgresql ###
#createuser -d -P -s postgres

### git ###
git config --global commit.gpgsign true
git config --global user.signingkey 99DC9E7993AEB537
git config --global core.excludesfile ~/.gitignore


### noisy ###
git clone https://github.com/1tayH/noisy.git

### web-traffic-generator ###
git clone https://github.com/ReconInfoSec/web-traffic-generator.git


### antivmdetection ###
git clone https://github.com/nsmfoo/antivmdetection.git


### dns_over_tls_over_tor ###
https://github.com/piskyscan/dns_over_tls_over_tor.git

### dispatch ###
git clone https://github.com/Netflix/dispatch-docker.git

## GPG ###
gpg --full-generate-key
gpg --armor --export {this-is-your-gpg-key-id}