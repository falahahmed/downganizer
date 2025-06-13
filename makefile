# Making the apt package from bash script

pac="downganizer"

VER ?= $(shell cat VERSION)

default:
	echo "Installing build dependencies"
	sudo apt-get install build-essential debhelper dh-make devscripts reprepro
	echo "Build dependencies installed"

	echo "Creating necessary directories"
	mkdir -p $(pac)/DEBIAN
	mkdir -p $(pac)/usr/local/bin
	mkdir -p apt-repo/conf
	echo "Directories created"
	cp $(pac).sh $(pac)/usr/local/bin/$(pac)
	cp -r lib $(pac)/usr/local/bin/
	echo "$(VER)" > VERSION

make config:
	echo "Origin: $(pac)" > apt-repo/conf/distributions
	echo "Label: $(pac)" >> apt-repo/conf/distributions
	echo "Suite: stable" >> apt-repo/conf/distributions
	echo "Codename: focal" >> apt-repo/conf/distributions
	echo "Version: $(VER)" >> apt-repo/conf/distributions
	echo "Architectures: amd64 focal" >> apt-repo/conf/distributions
	echo "Components: main" >> apt-repo/conf/distributions
	echo "Description: $(pac) package repository" >> apt-repo/conf/distributions

	echo "Created $(pac)/conf/distributions"

	echo "Package: $(pac)" > $(pac)/DEBIAN/control
	echo "Version: $(VER)" >> $(pac)/DEBIAN/control
	echo "Section: utils" >> $(pac)/DEBIAN/control
	echo "Priority: optional" >> $(pac)/DEBIAN/control
	echo "Architecture: all" >> $(pac)/DEBIAN/control
	echo "Maintainer: Falah Ahmed <kpfalah99@gmail.com>" >> $(pac)/DEBIAN/control
	echo "Description: A script to create a command from executable files." >> $(pac)/DEBIAN/control
	echo "   Currently, it is only available for files like .AppImage" >> $(pac)/DEBIAN/control
	echo "   I want to add more file extensions. A helping hand is always welcome." >> $(pac)/DEBIAN/control
	echo "   You can contact me at telegram: @chruxAdmin" >> $(pac)/DEBIAN/control
	echo "   github: @falahahmed" >> $(pac)/DEBIAN/control

	echo "Created $(pac)/DEBIAN/control"

build: 
	# Building debian package
	dpkg-deb --build $(pac)

	# make deb file executable
	sudo chmod 755 $(pac).deb

	# update apt repository
	reprepro -b apt-repo --ignore=wrongdistribution includedeb focal $(pac).deb

	# create package
	cd apt-repo && dpkg-scanpackages --arch all pool/ > Packages
	cd apt-repo && gzip -k Packages
	sudo chmod 755 apt-repo/pool/main/d/$(pac)/$(pac)_$(VER)_all.deb
	
clean:
	echo "Cleaning up..."
	rm -rf $(pac)/*
	rm -rf apt-repo/*
	rm -f $(pac).deb
	echo "Cleaned up"