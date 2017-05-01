# Syncthing Light

[![Github All Releases](https://img.shields.io/github/downloads/maxwelleite/syncthinglight/total.svg)](https://github.com/maxwelleite/syncthinglight/releases)

## Introduction

Syncthing Light is a simple Windows package installer (created in [Inno Setup](http://www.jrsoftware.org/isinfo.php)) for install and runs Syncthing as Windows Service (without any tray utility like [syncthing-tray](https://github.com/alex2108/syncthing-tray), [QSyncthingTray](https://github.com/sieren/QSyncthingTray) or others.

## Why

This should also aid those users without much technical experience to make a windows service works with Syncthing. Because the Syncthing developpers yeat don't provide a package installer for Windows for this functionality.

This ideia is based on [Syncthing Windows Installer](https://forum.syncthing.net/t/syncthing-windows-installer/2009) by Michael Jephcote.

**Note:** Automatic Upgrades do work with this installation for Syncthing only

## What's Included?

* [Syncthing v0.14.27](https://github.com/syncthing) (only latest stable builds)
* [winsw](https://github.com/kohsuke/winsw) ( Windows Service Wrapper)

## What does it do?

* Works on both x86 & x64 machines for Windows (multiarch)
* Installs winsw, Syncthing under C:\Syncthing
* Installs a service by the name of Syncthing
* Creates an entry in Add/Remove Programs so that you may uninstall (uninstalling retains your "config" folder under C:\Syncthing if you want)

## Todo

* Add the TCP port 22000 Windows firewall exception automatically.
* Fix issue "default folder" to "system32\Sync" directory. Because Syncthing is installed as a service under the "SYSTEM" account.
* Check if .NET Framework 2.0 is really installed (requirement for winsw) for work on old Windows XP. **Note:** The .NET Framework 2.0 is [installed since Windows Vista](https://blogs.msdn.microsoft.com/astebner/2007/03/14/mailbag-what-version-of-the-net-framework-is-included-in-what-version-of-the-os/).
* Execute the update for a new version for Syncthing if necessary after install
* Automatic download and install the latest Syncthing on installation runtime (not embedded approach)

## Known issue

After install will be open the Syncthing WebGUI (http://127.0.0.1:8384) on your default browser. You need expand the "default folder". Once expanded click the "Edit" button and finally the "Delete" button. This is because Syncthing is installed as a service under the "SYSTEM" account and sets the default share path up under the "system32\Sync" directory.

## Download

Precompiled binaries for Windows are downloadable in the [Releases](https://github.com/maxwelleite/syncthinglight/releases) section.
