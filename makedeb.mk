# Making the apt package from bash script

pac ?= $(shell cat PAC)
cmd=downganizer

target_dir=/home/chrux/Documents/Web/adekacciorg.github.io/lin-packs/pool/main/d/$(pac)

VER ?= $(shell cat VERSION)

GREEN=\033[0;32m
RED=\033[0;31m
WHITE=\033[1;37m

devdeps=$(shell apt list build-essential debhelper dh-make devscripts reprepro 2>/dev/null | grep -c "installed")

default:
	@echo "Checking build dependencies"
	@if [ $(devdeps) -eq 5 ]; then \
		echo "Dependencies installed. Proceeding..."; \
	else \
		echo "$(RED)Dependencies are not installed.$(WHITE) Please run $(GREEN) sudo make install$(WHITE)"; \
		exit 1; \
	fi

	@mkdir -p $(pac)/DEBIAN
	@mkdir -p $(pac)/usr/local/bin
	@mkdir -p apt-repo/conf
	@echo "Necessary directories created"
	@cp $(cmd).sh $(pac)/usr/local/bin/$(cmd)
	@cp -r lib $(pac)/usr/local/bin/
	@echo "Script files copied"

install:
	@echo "Installing build dependencies"
	@sudo apt-get install build-essential debhelper dh-make devscripts reprepro
	@echo "$(GREEN)Build dependencies installed"

config:
	@echo "Origin: $(pac)" > apt-repo/conf/distributions
	@echo "Label: $(pac)" >> apt-repo/conf/distributions
	@if [ "$(pac)" = "$(cmd)" ]; then \
		echo "Suite: stable" >> apt-repo/conf/distributions ; \
	else \
		echo "Suite: Beta" >> apt-repo/conf/distributions ; \
	fi
	@echo "Codename: focal" >> apt-repo/conf/distributions
	@echo "Version: $(VER)" >> apt-repo/conf/distributions
	@echo "Architectures: amd64 focal" >> apt-repo/conf/distributions
	@echo "Components: main" >> apt-repo/conf/distributions
	@echo "Description: $(pac) package repository" >> apt-repo/conf/distributions

	@echo "Created $(pac)/conf/distributions"

	@echo "Package: $(pac)" > $(pac)/DEBIAN/control
	@echo "Version: $(VER)" >> $(pac)/DEBIAN/control
	@echo "Section: utils" >> $(pac)/DEBIAN/control
	@echo "Priority: optional" >> $(pac)/DEBIAN/control
	@echo "Depends: inotify-tools (>= 3.22.6)" >> $(pac)/DEBIAN/control
	@echo "Architecture: all" >> $(pac)/DEBIAN/control
	@echo "Maintainer: Falah Ahmed <kpfalah99@gmail.com>" >> $(pac)/DEBIAN/control
	@echo "Description: A script to automate organizing download files" >> $(pac)/DEBIAN/control
	@echo "   You can utilize available options to organize your downloaded files" >> $(pac)/DEBIAN/control
	@echo "   I'm planning to extend organizing criteria and to develop gui. A helping hand is always welcome." >> $(pac)/DEBIAN/control
	@echo "   You can contact me at telegram: @chruxAdmin" >> $(pac)/DEBIAN/control
	@echo "   github: @falahahmed" >> $(pac)/DEBIAN/control

	@echo "Created $(pac)/DEBIAN/control"

build: 
	# Building debian package
	@dpkg-deb --build $(pac)
	@echo "Debian package built: $(pac).deb"

	# make deb file executable
	@sudo chmod 755 $(pac).deb

	# update apt repository
	@reprepro -b apt-repo --ignore=wrongdistribution includedeb focal $(pac).deb
	@echo "Package added to apt repository"

	# create package
	@cd apt-repo && dpkg-scanpackages --arch all pool/ > Packages
	@cd apt-repo && gzip -kf Packages
	@echo "Packages file created and compressed"
	@sudo chmod 755 apt-repo/pool/main/d/$(pac)/$(pac)_$(VER)_all.deb
	@echo "$(GREEN)Build process completed successfully!$(WHITE)"
	
transfer:
	@if [ ! -d "$(target_dir)" ]; then \
		mkdir -p "$(target_dir)" ; \
	fi
	@rm -f $(target_dir)/*
	@cp apt-repo/pool/main/d/$(pac)/$(pac)_$(VER)_all.deb $(target_dir)/
	@echo "Package transferred to pack-repo"

clean:
	@rm -rf $(pac)/*
	@rm -rf apt-repo/*
	@rm -f $(pac).deb
	@echo "Cleaned up"