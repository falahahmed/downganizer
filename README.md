# Organize your linux's Downloads directory with 'downganizer'

downganizer is a package to efficiently organize your Downloads directory in linux. It can organize the files in the Downloads directory, and also monitor the directory to organize files when downloaded.

## Table of contents

## Features

- Easy and efficient way to organize downloaded files.
- Move the files in Downloads directory to respective sub-directories.
- Monitor the direcotry and move each new file to respective sub-directory.

## Quick Start

### Installation

To get started, you need a linux distro, preferably debian based one. Follow the steps below to install the package.

1. add the repo link to your sources list, if you haven't already one it - our other repos are in the same repo. If you have added it once, you can skip this.
```
 echo "deb [trusted=yes] https://adekacciorg.github.io/lin-packs ./" | sudo tee /etc/apt/sources.list.d/adekacci.list
```

2. Update your apt list
```
 sudo apt update
```

3. Install downganizer
```
 sudo apt install downganizer
```

### Usage

Currently, there are two features that you can use:
1. `downganizer -v` or `downganizer --version` : To check the current version of the package.
2. `downganizer -h` or `downganizer --help` : To get basic info about the package
3. `downganizer do` : This will organize the files that are in the Downloads directory.
4. `downganizer start`: This will start monitoring downloads directory for any new file, and if found, it will move it to the respective sub-directory.

## Get in touch with us

### Community

To get in touch with us, please contact us through telegram.
> Telegram Channel: `@Adekacci`([link](https://t.me/Adekacci))
> Telegram Group : `@ChruxGroup`([link](https://t.me/ChruxGroup))