# better-anonymity

Better anonymity configurations.

## Summary

This project aims provide a framework for auditing, configuring, and verifying best practices for security, privacy, and anonymity on the latest macOS software. It utilizes a combination of tools from various resources to make regular, automated, up-to-date configuraiton possible.

## Table of Contents

* [Features](https://github.com/bkuhlmann/mac_os#features)
* [Screencast](https://github.com/bkuhlmann/mac_os#screencast)
* [Requirements](https://github.com/bkuhlmann/mac_os#requirements)
* [Setup](https://github.com/bkuhlmann/mac_os#setup)
* [Usage](https://github.com/bkuhlmann/mac_os#usage)
  * [Boot Disk](https://github.com/bkuhlmann/mac_os#boot-disk)
  * [Customization](https://github.com/bkuhlmann/mac_os#customization)
  * [Troubleshooting](https://github.com/bkuhlmann/mac_os#troubleshooting)
* [Development](https://github.com/bkuhlmann/mac_os#development)
* [License](https://github.com/bkuhlmann/mac_os#license)
* [Security](https://github.com/bkuhlmann/mac_os#security)
* [Code of Conduct](https://github.com/bkuhlmann/mac_os#code-of-conduct)
* [Contributions](https://github.com/bkuhlmann/mac_os#contributions)
* [Versions](https://github.com/bkuhlmann/mac_os#versions)
* [Community](https://github.com/bkuhlmann/mac_os#community)
* [Credits](https://github.com/bkuhlmann/mac_os#credits)

## Features

* Provides a command line interface, written in Bash, with no additional dependencies for
  installation and management of privacy, security, and anonymity on a macOS machine.
* Supports macOS boot disk creation for fresh install of operating system.
* Supports installing [Xcode Command Line Tools](https://developer.apple.com/xcode).
* Supports installing related [Homebrew](http://brew.sh) formulas and casks.
* Supports installing related [App Store](http://www.apple.com/macosx/whats-new/app-store.html) software.
* Supports installing related non-App Store software applications.
* Supports installing related software application extensions.
* Supports installing related dotfile configurations.
* Applies basic default security, privacy, and anonymity settings.
* Configures installed software to meet benchamark standards.
* Supports restoration of machine backups.

## Prerequisites

```
. Git
. Python3
  . Python3 Modules
    . pyyaml
    . xlwt
. Ruby
  . Gemfiles
    . asciidoctor
    . asciidoctor-pdf
    . rouge
```

## Getting Started

To work locally, first clone into the repository and install the required Python3 modules and Ruby gems:

```shell
git clone https://github.com/usnistgov/macos_security.git

cd macos_security

pip3 install -r requirements.txt --user

bundle install --binstubs --path gems
```

| ❗ | Never work off the `main`branch, always `git checkout` one of the OS branches. |
| -- | ---------------------------------------------------------------------------------- |

## Usage

The following will walk you through the steps of installing/re-installing your machine.

### Pre-Install

Ensure you have the following in place for your Silicon machine:

* Ensure a backup of your Apple, NAS, backup image, and Dropbox credentials are available.
* Ensure a recent backup of your machine exists and works properly.
* Ensure [Startup Security Utility](https://support.apple.com/en-us/HT208198) is disabled.
* Turn off your machine.
* Start your machine by pressing and holding the `POWER` button until you see startup options being loaded.
* Select Utilities → Startup Security Utility from the main menu.
* Select _Reduced Security_.
* Quit the utility and restart the machine.

### Install

* To install, run:

```shell
git clone https://github.com/better-wealth/better-anonymity.git
cd better-anonymity
```

* Run the following:

```shell
bin/run
```

* You will be presented with the following options (listed in order of use):

```
Boot:
   B:  Create boot disk.
Install:
   b:  Apply basic settings.
   t:  Install development tools.
  hf:  Install Homebrew Formulas.
  hc:  Install Homebrew Casks.
   m:  Install Mac App Store software.
   a:  Install application software.
   x:  Install application software extensions.
  df:  Install dotfiles.
  np:  Install Node packages.
  rg:  Install Ruby gems.
  rc:  Install Rust crates.
   d:  Apply default settings.
  cs:  Configure installed software.
   i:  Install everything (i.e. executes all install options in order listed).
Restore:
   R:  Restore settings from backup.
Manage:
   c:  Check status of managed software.
   C:  Caffeinate machine.
  ua:  Uninstall application software.
  ux:  Uninstall application software extension.
  ra:  Reinstall application software.
  rx:  Reinstall application software extension.
   w:  Clean work (temp) directory.
   q:  Quit/Exit.
```

Choose option `i` to run a full install or select a specific option to run a single action. Each
option is designed to be re-run if necessary. This can also be handy for performing upgrades,
re-running a missing/failed install, etc.

The option prompt can be skipped by passing the desired option directly to the `bin/run` script. For
example, executing `bin/run i` will execute the full install process.

The machine should be rebooted after all install tasks have completed to ensure all settings have
been loaded.

It is recommended that the `better-anonymity` project directory not be deleted and kept on the local machine in order to manage installed software and benefit from future upgrades.

### Post-Install

The following are additional steps, not easily automated, that are worth completing after the
install scripts have completed:

* System Preferences

  * Apple ID

    * Configure iCloud.
    * Enable Find My Mac.
  * Security & Privacy

    * General

      * Require password immediately after sleep or screen saver begins.
      * Enable message when screen is locked. Example: `<url> | <email> | <phone>`.
      * Allow your Apple Watch to unlock your Mac.
    * FileVault

      * Enable FileVault and save the recovery key in a secure location (i.e. 1Password).
    * Firewall

      * Enable.
      * Automatically allow signed software.
      * Enable stealth mode.
  * Internet Accounts

    * Add all accounts.
  * Touch ID

    * Rename fingerprint.
  * Keyboard

    * Keyboard

      * Slide *Key Repeat* to *Fast* (max).
      * Slide *Delay Until Repeat* to *Short* (max).
    * Shortcuts

      * Select *Launchpad and Dock* and uncheck  *Turn Dock Hiding On/Off* .
      * Select *Mission Control* and assign `CONTROL + OPTION + COMMAND + N` to  *Show Notification
        Center* .
      * Select *Screenshots* and uncheck all boxes.
      * Select *Spotlight* and uncheck all boxes.
  * Desktop and Screen Saver

    * Select  *Desktop* , click `+`, and choose custom image.
    * Select  *Screen Saver* , select  *Message* , enter custom message, start after 10 minutes, and check
      *show with clock* .
  * Bluetooth

    * Reconnect keyboard, mouse, and earbuds.
  * Network

    * Configure Wi-Fi.
  * Printers & Scanners

    * Add printer/scanner.
  * Users & Groups

    * Update avatar image.
    * Remove unused login items.
    * Disable guest account.
  * Wallet and Apple Pay

    * Reenable all accounts and assign default card.
  * Sound

    * Sound Effects

      * Uncheck  *Play sound on startup* .
      * Uncheck  *Play user interface sound effects* .
    * Battery

      * Click on *Battery* and uncheck  *Show battery status in menu bar* .
      * Click on *Power Adapter* and check  *Prevent computer from sleeping automatically when the
        display is off* .
  * Notifications

    * Do Not Disturb

      * Enable *Do Not Disturb* from 9pm to 7am.
      * Enable  *When display is sleeping* .
      * Enable  *When screen is locked* .
      * Enable  *When mirroring* .
      * Disable  *Allow calls from everyone* .
      * Enable allow repeated calls.
    * Applications

      * Select *Banners* for all apps.
      * Disable  *Show notifications on lock screen* .
      * Disable  *Play sounds for notifications* .
* iStat Menus

  * Double click, within the Applications folder, to install as a system preference.
* Carbon Copy Cloner

  * Rename old backup, create new backup, and set frequency schedule

### Customization

While this project’s configuration is opinionated and tailored for my setup, you can easily fork
this project and customize it for your environment. Start by editing the files found in the `config/bin`
and `config/lib` directories.

*TIP* : The installer determines which applications/extensions to install as defined in the `config/settings.sh` script. Applications defined with the “APP_NAME” suffix and extensions defined with the “EXTENSION_PATH” suffix inform the installer what to care about. Removing/commenting out these applications/extensions within the `config/settings.sh` file will cause the installer to skip these applications/extensions.

All executable scripts can be found in the `config/bin` folder:

* `config/bin/apply_basic_settings` (optional, customizable): Applies basic and initial settings for
  setting up a machine.
* `config/bin/apply_default_settings` (optional, customizable): Applies bare minimum system and application
  defaults.
* `config/bin/configure_software` (optional, customizable): Configures installed software as part of the
  post install process.
* `config/bin/create_boot_disk` (optional): Creates a macOS boot disk.
* `config/bin/install_app_store` (optional, customizable): Installs macOS, GUI-based, App Store
  applications.
* `config/bin/install_applications` (optional, customizable): Installs macOS, GUI-based, non-App Store
  applications.
* `config/bin/install_dev_tools` (required): Installs macOS development tools required by Homebrew.
* `config/bin/install_dotfiles` (optional, customizable): Installs personal dotfiles so the system is
  tailored to your workflow.
* `config/bin/install_extensions` (optional, customizable): Installs macOS application extensions and
  add-ons.
* `config/bin/install_homebrew_casks` (optional, customizable): Installs Homebrew Formulas.
* `config/bin/install_homebrew_formulas` (optional, customizable): Installs Homebrew Casks.
* `config/bin/install_node_packages` (optional, customizable): Installs Node packages.
* `config/bin/install_ruby_gems` (optional, customizable): Installs Ruby gems.
* `config/bin/install_rust_crates` (optional, customizable): Installs Rust crates.
* `config/bin/restore_backup` (optional, customizable): Restores system/application settings from backup
  image.

The `lib` folder provides the base framework for installing, re-installing, and uninstalling
software. Everything provided via the [`config/lib` ](https://www.alchemists.io/projects/mac_os-config)folder is built upon the functions found in the `lib` folder.

* `config/lib/settings.sh`: Defines global settings for software applications, extensions, etc.

### Troubleshooting

* **Pi-hole** : When using [Pi-hole](https://pi-hole.net), you might need to temporarily disable
  prior to upgrading as you might experience various errors with Apple not being able to detect an
  internet connection which prevents the installer from working.
* **Recovery Mode** : When using the boot disk and the installer fails in some catastrophic manner,
  reboot the machine into recovery mode — POWER (Silicon) or
  COMMAND + r (Intel) buttons — to download and install the
  last operating system used. Alternatively, you can also use COMMAND

  OPTION + r (Intel) to attempt to download the latest operating
  system.
* **NVRAM/PRAM Reset** : When using the boot disk, you might experience a situation where you see a
  black screen with a white circle and diagonal line running through it. This means macOS lost or
  can’t find the boot disk for some reason. To correct this, shut down and boot up the system again
  while holding down OPTION + COMMAND + r

  p (Intel) keys simultaneously. You might want to wait for the system boot sound
  to happen a few times before releasing the keys. This will clear the system NVRAM/PRAM. At this
  point you can shut down and restart the system following the boot disk instructions (the boot disk
  will be recognized now).
* **System Management Controller (SMC) Reset** : Sometimes it can help to reset the SMC to improve
  system speed. To fix, follow these steps:
* Shut down your Mac.
* Hold down CONTROL + OPTION on the left side of the keyboard
  and SHIFT on the right side of the keyboard.
* After seven seconds, hold down the Power button as well.
* Release all keys after another seven seconds.
* Turn on your Mac.

## Security vs. Privacy vs. Anonymity

Quite simply:

• Privacy is a state of being free from observation.

• Security is a state of being free from danger.

• Anonymity is a state of being free from identification.

First off, there is overlap among the three concepts. Being secure will provide you with privacy, and being anonymous will also provide you with privacy. But each of these terms does mean something different.

Privacy is achieved when a user is free of any surveillance. It means, that no one can see their activity and sensitive information.
Security is achieved when a user is safe from danger. In the digital world, it means that no one can infect their device, get into it, interfere with connection, and steal personal data.
Anonymity is achieved when a user can’t be identified. It means, that the details about their identity are hidden.

### Security:

Security is a set of precautions and measures for protection against potential harm to your person and reputation, and files directly or indirectly from malicious parties.

Security incidents can cause direct harm to their victims. This could be a data breach that compromises passwords and other critical information, or a virus that damages your files and hardware—by turning off your device’s cooling fan, for example.

It’s natural to view security as the most important of the three. After all, compared to the other two, security is a need rather than a right or a preference. But more often than not, ensuring user security is used as an excuse to undermine rights to privacy and anonymity.

You need security to protect any type of information that others could use against you, such as private images and financial information. Look for services with the utmost security when dealing with password managers, antivirus, and financial services.

### Privacy:

Privacy is the ability to keep certain data and information about yourself exclusive to you and control who and what has access to it.

Make privacy your priority when using apps or services that have access to your personal information such as full name, email address, phone number, location, etc.

### Anonymity:

To be anonymous is to hide or conceal your identity, but not your actions. In the digital world, you can be anonymous by preventing online entities from collecting or storing data that could be used to identify you.

Anonymity is important for freedom of speech and particularly for whistleblowers. That's especially true in areas of the world where having certain viewpoints and opinions could endanger your safety or put your career and future at risk.

Anonymity also often overlaps with privacy, allowing you to browse the internet without worrying about tracking logs. These record your every move and use collected information to build a profile about you or include you in studies and statistics you didn’t consent to.

Online anonymity is a case-by-case need. Generally, you’d want to be anonymous anytime you’re doing something you wouldn't want to be traced back to you or your online personas.

It’s important when discussing sensitive topics; whether it’s asking for advice on online forums, expressing fringe political views, or exposing a public person or commercial entity's misconduct.

### Differences between Security and Privacy

| SECURITY                                                                                                                                                                   | PRIVACY                                                                                                                                                                                                                  |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Focuses on how policies get enforced                                                                                                                                       | Focuses on what kinds of data are important                                                                                                                                                                              |
| Sets methods, policies, and means to secure personal information                                                                                                           | Governs the distribution of data sharing, collecting, and usage                                                                                                                                                          |
| Protects from users accessing your data and other types of information                                                                                                     | Sets criteria for usage, collection, retention, deletion, and storage of data                                                                                                                                            |
| Prevents data being compromised by malicious insiders and external attackers                                                                                               | Ability to block entities, such as websites, browser, cable companies, and other internet service providers, that can track your information and browser history                                                         |
| Typical Data Security Tools: Anti-malware software, Antivirus software, Data masking software, Data loss prevention, Event management software, Identity/access management | Typical Data Privacy Tools: Ad and tracker blockers, Browser extensions/add-ons, Email services, Encrypted messaging, File encryption software, Password managers, Private browsers, Private search engines, Web proxies |

## CIS Checklist

|    #    |                          Level 1                          |                   Level 2                   |  Level 3  |                                                  Recommendation                                                  |      Assessment Status      |
| :-----: | :-------------------------------------------------------: | :-----------------------------------------: | :--------: | :--------------------------------------------------------------------------------------------------------------: | :-------------------------: |
|   1.1   | Install Updates, Patches and Additional Security Software |                                            |            |                                  Ensure All Apple-provided Software Is Current                                  |          Automated          |
|   1.2   | Install Updates, Patches and Additional Security Software |                                            |            |                                          Ensure Auto Update Is Enabled                                          |          Automated          |
|   1.3   | Install Updates, Patches and Additional Security Software |                                            |            |                              Ensure Download New Updates When Available Is Enabled                              |          Automated          |
|   1.4   | Install Updates, Patches and Additional Security Software |                                            |            |                                   Ensure Installation of App Update Is Enabled                                   |          Automated          |
|   1.5   | Install Updates, Patches and Additional Security Software |                                            |            |              Ensure System Data Files and Security Updates Are Downloaded Automatically Is Enabled              |          Automated          |
|   1.6   | Install Updates, Patches and Additional Security Software |                                            |            |                                    Ensure Install of macOS Updates Is Enabled                                    |          Automated          |
|   1.7   | Install Updates, Patches and Additional Security Software |                                            |            |                        Ensure Software Update Deferment Is Less Than or Equal to 30 Days                        |          Automated          |
|   1.8   | Install Updates, Patches and Additional Security Software |                                            |            |                Ensure Computer Name Does Not Contain PII or Protected Organizational Information                |           Manual           |
|  2.1.1  |                    System Preferences                    |               Dock & Menu Bar               |            |                               Ensure Show Bluetooth Status in Menu Bar Is Enabled                               |          Automated          |
|  2.1.2  |                    System Preferences                    |               Dock & Menu Bar               |            |                                 Ensure Show Wi-Fi status in Menu Bar Is Enabled                                 |          Automated          |
|  2.2.1  |                    System Preferences                    |                 Date & Time                 |            |                               Ensure "Set time and date automatically" Is Enabled                               |          Automated          |
|  2.2.2  |                    System Preferences                    |                 Date & Time                 |            |                                   Ensure Time Is Set Within Appropriate Limits                                   |          Automated          |
|  2.3.1  |                    System Preferences                    |           Desktop & Screen Saver           |            |               Ensure an Inactivity Interval of 20 Minutes Or Less for the Screen Saver Is Enabled               |          Automated          |
|  2.3.2  |                    System Preferences                    |           Desktop & Screen Saver           |            |                                      Ensure Screen Saver Corners Are Secure                                      |          Automated          |
|  2.4.1  |                    System Preferences                    |                   Sharing                   |            |                                      Ensure Remote Apple Events Is Disabled                                      |          Automated          |
|  2.4.2  |                    System Preferences                    |                   Sharing                   |            |                                       Ensure Internet Sharing Is Disabled                                       |          Automated          |
|  2.4.3  |                    System Preferences                    |                   Sharing                   |            |                                        Ensure Screen Sharing Is Disabled                                        |          Automated          |
|  2.4.4  |                    System Preferences                    |                   Sharing                   |            |                                        Ensure Printer Sharing Is Disabled                                        |          Automated          |
|  2.4.5  |                    System Preferences                    |                   Sharing                   |            |                                         Ensure Remote Login Is Disabled                                         |          Automated          |
|  2.4.6  |                    System Preferences                    |                   Sharing                   |            |                                       Ensure DVD or CD Sharing Is Disabled                                       |          Automated          |
|  2.4.7  |                    System Preferences                    |                   Sharing                   |            |                                       Ensure Bluetooth Sharing Is Disabled                                       |          Automated          |
|  2.4.8  |                    System Preferences                    |                   Sharing                   |            |                                         Ensure File Sharing Is Disabled                                         |          Automated          |
|  2.4.9  |                    System Preferences                    |                   Sharing                   |            |                                       Ensure Remote Management Is Disabled                                       |          Automated          |
| 2.4.10 |                    System Preferences                    |                   Sharing                   |            |                                        Ensure Content Caching Is Disabled                                        |          Automated          |
| 2.4.11 |                    System Preferences                    |                   Sharing                   |            |                                            Ensure AirDrop Is Disabled                                            |          Automated          |
| 2.4.12 |                    System Preferences                    |                   Sharing                   |            |                                         Ensure Media Sharing Is Disabled                                         |          Automated          |
| 2.4.13 |                    System Preferences                    |                   Sharing                   |            |                                       Ensure AirPlay Receiver Is Disabled                                       |          Automated          |
| 2.5.1.1 |                    System Preferences                    |             Security & Privacy             | Encryption |                                           Ensure FileVault Is Enabled                                           |          Automated          |
| 2.5.1.2 |                    System Preferences                    |             Security & Privacy             | Encryption |                                Ensure all user storage APFS volumes are encrypted                                |           Manual           |
| 2.5.1.3 |                    System Preferences                    |             Security & Privacy             | Encryption |                            Ensure all user storage CoreStorage volumes are encrypted                            |           Manual           |
| 2.5.2.1 |                    System Preferences                    |             Security & Privacy             |  Firewall  |                                            Ensure Firewall Is Enabled                                            |          Automated          |
| 2.5.2.2 |                    System Preferences                    |             Security & Privacy             |  Firewall  |                                     Ensure Firewall Stealth Mode Is Enabled                                     |          Automated          |
|  2.5.3  |                    System Preferences                    |             Security & Privacy             |            |                                       Ensure Location Services Is Enabled                                       |          Automated          |
|  2.5.4  |                    System Preferences                    |             Security & Privacy             |            |                                          Audit Location Services Access                                          |           Manual           |
|  2.5.5  |                    System Preferences                    |             Security & Privacy             |            |                          Ensure Sending Diagnostic and Usage Data to Apple Is Disabled                          |          Automated          |
|  2.5.6  |                    System Preferences                    |             Security & Privacy             |            |                                       Ensure Limit Ad Tracking Is Enabled                                       |          Automated          |
|  2.5.7  |                    System Preferences                    |             Security & Privacy             |            |                                           Ensure Gatekeeper Is Enabled                                           |          Automated          |
|  2.5.8  |                    System Preferences                    |             Security & Privacy             |            |                             Ensure a Custom Message for the Login Screen Is Enabled                             |          Automated          |
|  2.5.9  |                    System Preferences                    |             Security & Privacy             |            |                  Ensure an Administrator Password Is Required to Access System-Wide Preferences                  |          Automated          |
| 2.5.10 |                    System Preferences                    |             Security & Privacy             |            |             Ensure a Password is Required to Wake the Computer From Sleep or Screen Saver Is Enabled             |          Automated          |
| 2.6.1.1 |                    System Preferences                    |                  Apple ID                  |   iCloud   |                                              Audit iCloud Keychain                                              |           Manual           |
| 2.6.1.2 |                    System Preferences                    |                  Apple ID                  |   iCloud   |                                                Audit iCloud Drive                                                |           Manual           |
| 2.6.1.3 |                    System Preferences                    |                  Apple ID                  |   iCloud   |                            Ensure iCloud Drive Document and Desktop Sync Is Disabled                            |          Automated          |
|  2.6.2  |                    System Preferences                    |                  Apple ID                  |            |                                        Audit App Store Password Settings                                        |           Manual           |
|  2.7.1  |                    System Preferences                    |                Time Machine                |            |                                      Ensure Backup Automatically is Enabled                                      |          Automated          |
|  2.7.2  |                    System Preferences                    |                Time Machine                |            |                                    Ensure Time Machine Volumes Are Encrypted                                    |          Automated          |
|  2.8.1  |                    System Preferences                    |           Battery (Energy Saver)           |            |                                    Ensure Wake for Network Access Is Disabled                                    |          Automated          |
|  2.8.2  |                    System Preferences                    |           Battery (Energy Saver)           |            |                                   Ensure Power Nap Is Disabled for Intel Macs                                   |          Automated          |
|  2.8.3  |                    System Preferences                    |           Battery (Energy Saver)           |            |                              Ensure the OS is not Activate When Resuming from Sleep                              |          Automated          |
|   2.9   |                    System Preferences                    |                                            |            |                                     Ensure Legacy EFI Is Valid and Updating                                     |          Automated          |
|  2.10  |                    System Preferences                    |                                            |            |                                               Audit Siri Settings                                               |           Manual           |
|  2.11  |                    System Preferences                    |                                            |            |                                         Audit Universal Control Settings                                         |           Manual           |
|  2.12  |                    System Preferences                    |                                            |            |                                  Audit Touch ID and Wallet & Apple Pay Settings                                  |           Manual           |
|  2.13  |                    System Preferences                    |                                            |            |                                       Audit Notification & Focus Settings                                       |           Manual           |
|  2.14  |                    System Preferences                    |                                            |            |                                    Audit Passwords System Preference Setting                                    |           Manual           |
|   3.1   |                   Logging and Auditing                   |                                            |            |                                       Ensure Security Auditing Is Enabled                                       |          Automated          |
|   3.2   |                   Logging and Auditing                   |                                            |            | Ensure Security Auditing Flags For User-Attributable Events Are Configured Per Local Organizational Requirements |          Automated          |
|   3.3   |                   Logging and Auditing                   |                                            |            |                     Ensure install.log Is Retained for 365 or More Days and No Maximum Size                     |          Automated          |
|   3.4   |                   Logging and Auditing                   |                                            |            |                                  Ensure Security Auditing Retention Is Enabled                                  |          Automated          |
|   3.5   |                   Logging and Auditing                   |                                            |            |                                                 Ensure Access to                                                 | Audit Records Is Controlled |
|   3.6   |                   Logging and Auditing                   |                                            |            |                                Ensure Firewall Logging Is Enabled and Configured                                |          Automated          |
|   3.7   |                   Logging and Auditing                   |                                            |            |                                             Audit Software Inventory                                             |           Manual           |
|   4.1   |                  Network Configurations                  |                                            |            |                                 Ensure Bonjour Advertising Services Is Disabled                                 |          Automated          |
|   4.2   |                  Network Configurations                  |                                            |            |                                          Ensure HTTP Server Is Disabled                                          |          Automated          |
|   4.3   |                  Network Configurations                  |                                            |            |                                          Ensure NFS Server Is Disabled                                          |          Automated          |
|  5.1.1  |      System Access, Authentication and Authorization      | File System Permissions and Access Controls |            |                                          Ensure Home Folders Are Secure                                          |          Automated          |
|  5.1.2  |      System Access, Authentication and Authorization      | File System Permissions and Access Controls |            |                            Ensure System Integrity Protection Status (SIP) Is Enabled                            |          Automated          |
|  5.1.3  |      System Access, Authentication and Authorization      | File System Permissions and Access Controls |            |                               Ensure Apple Mobile File Integrity (AMFI) Is Enabled                               |          Automated          |
|  5.1.4  |      System Access, Authentication and Authorization      | File System Permissions and Access Controls |            |                                   Ensure Sealed System Volume (SSV) Is Enabled                                   |          Automated          |
|  5.1.5  |      System Access, Authentication and Authorization      | File System Permissions and Access Controls |            |                     Ensure Appropriate Permissions Are Enabled for System Wide Applications                     |          Automated          |
|  5.1.6  |      System Access, Authentication and Authorization      | File System Permissions and Access Controls |            |                            Ensure No World Writable Files Exist in the System Folder                            |          Automated          |
|  5.1.7  |      System Access, Authentication and Authorization      | File System Permissions and Access Controls |            |                            Ensure No World Writable Files Exist in the Library Folder                            |          Automated          |
|  5.2.1  |      System Access, Authentication and Authorization      |             Password Management             |            |                             Ensure Password Account Lockout Threshold Is Configured                             |          Automated          |
|  5.2.2  |      System Access, Authentication and Authorization      |             Password Management             |            |                                   Ensure Password Minimum Length Is Configured                                   |          Automated          |
|  5.2.3  |      System Access, Authentication and Authorization      |             Password Management             |            |                     Ensure Complex Password Must Contain Alphabetic Characters Is Configured                     |           Manual           |
|  5.2.4  |      System Access, Authentication and Authorization      |             Password Management             |            |                       Ensure Complex Password Must Contain Numeric Character Is Configured                       |           Manual           |
|  5.2.5  |      System Access, Authentication and Authorization      |             Password Management             |            |                       Ensure Complex Password Must Contain Special Character Is Configured                       |           Manual           |
|  5.2.6  |      System Access, Authentication and Authorization      |             Password Management             |            |              Ensure Complex Password Must Contain Uppercase and Lowercase Characters Is Configured              |           Manual           |
|  5.2.7  |      System Access, Authentication and Authorization      |             Password Management             |            |                                        Ensure Password Age Is Configured                                        |          Automated          |
|  5.2.8  |      System Access, Authentication and Authorization      |             Password Management             |            |                                      Ensure Password History Is Configured                                      |          Automated          |
|   5.3   |      System Access, Authentication and Authorization      |                                            |            |                                  Ensure the Sudo Timeout Period Is Set to Zero                                  |          Automated          |
|   5.4   |      System Access, Authentication and Authorization      |                                            |            |                          Ensure a Separate Timestamp Is Enabled for Each User/tty Combo                          |          Automated          |
|   5.5   |      System Access, Authentication and Authorization      |                                            |            |                                      Ensure the "root" Account Is Disabled                                      |          Automated          |
|   5.6   |      System Access, Authentication and Authorization      |                                            |            |                                        Ensure Automatic Login Is Disabled                                        |          Automated          |
|   5.7   |      System Access, Authentication and Authorization      |                                            |            |             Ensure an Administrator Account Cannot Login to Another User's Active and Locked Session             |          Automated          |
|   5.8   |      System Access, Authentication and Authorization      |                                            |            |                                       Ensure a Login Window Banner Exists                                       |          Automated          |
|   5.9   |      System Access, Authentication and Authorization      |                                            |            |                                Ensure Users' Accounts Do Not Have a Password Hint                                |          Automated          |
|  5.10  |      System Access, Authentication and Authorization      |                                            |            |                                      Ensure Fast User Switching Is Disabled                                      |           Manual           |
|  5.11  |      System Access, Authentication and Authorization      |                                            |            |                               Ensure Secure Keyboard Entry Terminal.app Is Enabled                               |          Automated          |
|  6.1.1  |               User Accounts and Environment               |      Accounts Preferences Action Items      |            |                           Ensure Login Window Displays as Name and Password Is Enabled                           |          Automated          |
|  6.1.2  |               User Accounts and Environment               |      Accounts Preferences Action Items      |            |                                      Ensure Show Password Hints Is Disabled                                      |          Automated          |
|  6.1.3  |               User Accounts and Environment               |      Accounts Preferences Action Items      |            |                                         Ensure Guest Account Is Disabled                                         |          Automated          |
|  6.1.4  |               User Accounts and Environment               |      Accounts Preferences Action Items      |            |                                Ensure Guest Access to Shared Folders Is Disabled                                |          Automated          |
|  6.1.5  |               User Accounts and Environment               |      Accounts Preferences Action Items      |            |                                   Ensure the Guest Home Folder Does Not Exist                                   |          Automated          |
|   6.2   |               User Accounts and Environment               |                                            |            |                              Ensure Show All Filename Extensions Setting is Enabled                              |          Automated          |
|   6.3   |               User Accounts and Environment               |                                            |            |                           Ensure Automatic Opening of Safe Files in Safari Is Disabled                           |          Automated          |

## Useful References

### Security

- https://github.com/usnistgov/macos_security
- https://github.com/drduh/macOS-Security-and-Privacy-Guide
- https://github.com/alichtman/stronghold
- https://github.com/CISOfy/lynis
- https://macpaw.com/mac-security-guide

### Privacy

- https://privacy.sexy/
- https://www.privacytools.io/
- https://www.privacyguides.org/
- https://www.privacyguides.net/

### Anonymity

- https://anonymousplanet.org/guide.html
- https://github.com/Anon-Planet/thgtoa

### Protocols

- https://en.wikipedia.org/wiki/Matrix_(protocol)
- https://geti2p.net/en/
- https://freenetproject.org/

### Operating Systems

- https://tails.boum.org/
- https://www.whonix.org/
- https://www.qubes-os.org/

### Browsers

- https://www.torproject.org/download/
- https://gitlab.com/CHEF-KOCH/brave-browser-hardening
- https://forum.xda-developers.com/t/script-brave-browser-hardener.4466825/
- https://librewolf.net/
- https://www.mozilla.org/en-US/firefox/new/

### Software & Services

- https://bytzvpn.com/
- https://github.com/robbraxman/braxme
- https://medium.com/@brax_me
- https://whatthezuck.net/
- https://murusfirewall.com/murus/
- KeepassXC
- Signal
- Session
- VSCodium
