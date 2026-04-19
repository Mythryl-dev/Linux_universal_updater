
# Documentation

This script provides a unified interface to update multiple Linux distributions
with their respective package managers. It supports system-level, Flatpak, Snap and Waydroid updates, and includes a self-update feature.

# Supported Distros / Package Managers:
The script automatically detects your distro and offers relevant update options.
| Distro Family                     | Package Managers              |
|----------------------------------|-------------------------------|
| Debian / Ubuntu / Mint / Neon    | apt, nala, pkcon              |
| Arch / Manjaro / Garuda          | pacman, paru, yay             |
| Fedora / RHEL / CentOS           | dnf, yum                      |
| OpenSUSE                         | zypper                        |
| Void                             | xbps                          |
| Gentoo                           | emerge                        |
| Puppy Linux                      | ppm / pkg                     |
| TinyCore Linux                   | tce-update                    |
| Slackware                        | slackpkg                      |
| Alpine                           | apk                           |

# Semi Supported Distros (Functionally need's to be tested further):
 The script automatically detects your distro / packagemanager and offers relevant update options.
  -  &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; 

# Other Supported Package formats and tools:
- Flatpak
- Snap
- Waydroid
# Setup
To set up the script enter the following command into your terminal:

```
sudo wget -O /usr/bin/update https://raw.githubusercontent.com/Mythryl-dev/Linux_universal_updater/refs/heads/main/Update.sh && sudo chmod 755 /usr/bin/update
```

afterwards restart your terminal by simply closing it and reopening it

# How to use ?
Simply enter

```
sudo update
```

into your shell, the script will then start automaticly execute itself

# Notes
This script is not finished yet as can be seen in the Documentation contained in the script itself
Therefore please be patient if some feature are missing or not yet working properly.

