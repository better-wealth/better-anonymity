#!/usr/bin/env bash

set -e

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Functions                                                                   #
###############################################################################

dmg-install () {
  if [[ $# -lt 1 ]]; then
    echo "Usage: dmg-install [url]"
    exit 1
  fi
  url=$*
  # Generate a random file name
  tmp_file=/tmp/`openssl rand -base64 10 | tr -dc '[:alnum:]'`.dmg
  apps_folder='/Applications'

  # Download file
  echo "Downloading $url..."
  curl -# -L -o $tmp_file $url
  echo "Mounting image..."
  volume=`hdiutil mount $tmp_file | tail -n1 | perl -nle '/(\/Volumes\/.*?$)/; print $1'`
  # Locate .app folder and move to /Applications
  pkg=`find $volume -regex ".*\.pkg" -maxdepth 1 -type f -print0`
  app=`find $volume -regex ".*\.app" -maxdepth 1 -type d -print0`
  if [[ ! -z "$pkg" ]] && [ "$pkg" == *"Install.pkg"* ]; then
    echo "Installing $pkg into target /..."
    sudo installer -pkg $pkg -target /
  elif [[ ! -z "$app" ]] && [ "$app" != *"Uninstall.app"* ]; then
    echo "Copying `echo $app | awk -F/ '{print $NF}'` into $apps_folder..."
    cp -ir $app $apps_folder
  else
    echo "Unknown pkg or app... Cleaning up and exiting..."
    # Unmount volume, delete temporal file
    hdiutil unmount $volume -quiet
    rm -f $tmp_file
    exit 1
  fi
  # Unmount volume, delete temporal file
  echo "Cleaning up..."
  hdiutil unmount $volume -quiet
  rm -f $tmp_file
  echo "Done!"
}

zip-install () {
  if [[ $# -lt 1 ]]; then
    echo "Usage: zip-install [url]"
    exit 1
  fi
  url=$*
  # Generate a random file name
  tmp_file=/tmp/`openssl rand -base64 10 | tr -dc '[:alnum:]'`.zip
  apps_folder='/Applications'
  # Download file
  echo "Downloading $url..."
  curl -# -L -o $tmp_file $url
  echo "Unzipping file..."
  unzip -d "/tmp/unzip/" $tmp_file
  # Locate .app folder and move to /Applications
  pkg=`find /tmp/unzip -regex ".*\.pkg" -maxdepth 1 -type f -print0`
  app=`find /tmp/unzip -regex ".*\.app" -maxdepth 1 -type d -print0`
  if [[ ! -z "$pkg" ]] && [ "$pkg" == *"Install.pkg"* ]; then
    echo "Installing $pkg into target /..."
    sudo installer -pkg $pkg -target /
  elif [[ ! -z "$app" ]] && [ "$app" != *"Uninstall.app"* ]; then
    echo "Copying `echo $app | awk -F/ '{print $NF}'` into $apps_folder..."
    cp -ir $app $apps_folder
  else
    echo "Unknown pkg or app... Cleaning up and exiting..."
    rm -f $tmp_file
    rm -rf /tmp/unzip
    exit 1
  fi
  # Delete temporal file
  echo "Cleaning up..."
  rm -f $tmp_file
  rm -rf /tmp/unzip
  echo "Done!"
}

###############################################################################
# System info                                                                 #
###############################################################################

cpu=$(sysctl -n machdep.cpu.brand_string)

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

###############################################################################
# Energy saving                                                               #
###############################################################################

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the screenshots folder
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

###############################################################################
# Spotlight                                                                   #
###############################################################################

###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true

###############################################################################
# Time Machine                                                                #
###############################################################################

###############################################################################
# Activity Monitor                                                            #
###############################################################################

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

###############################################################################
# Mac App Store                                                               #
###############################################################################

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Messages                                                                    #
###############################################################################





echo "GETTING XCODE COMMAND LINE TOOLS";
echo;
xcode-select --install;

echo "GETTING HOMEBREW";
echo;
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
brew update;

echo "SETTING UP GPG TOOLS";
echo;
brew install gpg
echo;
echo "GETTING pinentry-mac";
echo;
brew install pinentry-mac;
echo;
echo "GETTING gnupg";
echo;
brew install gnupg;
echo;
echo "GETTING 'GPG Keychain.app'";
dmg-install https://gpgtools.org/download;
echo -e "default-cache-ttl 600\nmax-cache-ttl 7200\npinentry-program /usr/local/bin/pinentry-mac\npinentry-program /usr/local/bin/pinentry-mac\n" > $HOME/.gnupg/gpg-agent.conf;
echo;
echo "GETTING DEVELOPER TOOLS";
echo;
echo "GETTING coreutils";
brew install coreutils;
echo;
echo "GETTING curl";
brew install curl;
curl -o ~/.curlrc https://raw.githubusercontent.com/drduh/config/master/curlrc;
echo;
echo "GETTING asdf";
brew install asdf;
#echo -e ". $(brew --prefix asdf)/asdf.sh" >> ~/.zshrc
#echo -e "fpath=(${ASDF_DIR}/completions $fpath)\nautoload -Uz compinit\ncompinit" >> ~/.zshrc
echo;
echo "GETTING docker";
if [[ "$cpu" == *"Intel"* ]]; then
    dmg-install https://desktop.docker.com/mac/main/amd64/Docker.dmg;
elif [[ "$cpu" == *"M1"* ]]; then
    dmg-install https://desktop.docker.com/mac/main/arm64/Docker.dmg;
else
    echo "Uknown system CPU chip... Skipping Docker download";
fi
brew install openssl; 
brew install readline;
brew install sqlite3;
brew install xz;
brew install zlib;
brew install wget;
brew install macvim;
brew install jq;
brew install gh;
brew install sbt;
brew install scala;
brew install maven;
brew install npm;
brew install r;
brew install ccache;
brew install awscli;
brew install postgresql;
brew install mas;
### ULTIMATE VIM ###
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime;
sh ~/.vim_runtime/install_awesome_vimrc.sh;

echo;
echo "CREATING GLOBAL .gitignore FILE...";
echo -e "# VSCode\n/.elixir_ls/\n\n# Node\nnpm-debug.log\n\n# Mac\n.DS_Store\n\n# Windows\nThumbs.db\n\n# IntelliJ\n.idea/\n\n# vi\n*~\n\n# General\nlog/\n*.log\n\n# etc...\n" > $HOME/.gitignore;

echo;
echo "CONFIGURING git TO USE GLOBAL .gitignore...";
git config --global core.excludesfile $HOME/.gitignore;

echo "GETTING Postman...";
if [[ "$cpu" == *"Intel"* ]]; then
    zip-install https://dl.pstmn.io/download/latest/osx_64;
elif [[ "$cpu" == *"M1"* ]]; then
    zip-install https://dl.pstmn.io/download/latest/osx_arm64;
else
    echo "Uknown system CPU chip... Skipping Postman download";
fi

echo "GETTING pulumi";
brew install pulumi;

echo;
echo "GETTING INTERNET PRIVACY TOOLS";
#DNSCRYPT
echo;
echo "GETTING dnscrypt-proxy";
brew install dnscrypt-proxy;
cat ./homebrew.mxcl.dnscrypt-proxy.plist > /Library/LaunchDaemons/homebrew.mxcl.dnscrypt-proxy.plist;
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnscrypt-proxy.plist && sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnscrypt-proxy.plist;
sudo brew services start dnscrypt-proxy;
#DNSMASQ
echo;
echo "GETTING dnsmasq";
brew install dnsmasq;
cat ./homebrew.mxcl.dnsmasq.plistm > /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plistm;
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist && sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist;
sudo brew services start dnsmasq;
#PRIVOXY
echo;
echo "GETTING privoxy";
brew install privoxy;
brew services start privoxy;
#TOR
echo;
echo "GETTING tor";
brew install tor;
brew services start tor;
echo;
echo "GETTING torsocks";
brew install torsocks;


#PYTHON MANAGEMENT
echo;
echo "GETTING PYTHON TOOLS";
echo;
echo "GETTING pyenv";
brew install pyenv;
echo;
echo "GETTING pipenv";
brew install pipenv;
echo;
echo "GETTING xxenv-latest";
git clone https://github.com/momo-lab/xxenv-latest.git



brew install --cask rstudio;
brew install --cask librewolf;
brew install --cask visual-studio-code;
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";

# INSTALL FIREFOX
# SET FIREFOX CONFIG SETTINGS
# MAKE FIREFOX DEFAULT BROWSER

