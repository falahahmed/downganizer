# Making the arch package from bash script

pac ?= $(shell cat PAC)
cmd=downganizer
pkgrel ?= $(shell cat pkgrel)

target_dir=/home/chrux/Documents/adekacciorg.github.io/man-pacs

VER ?= $(shell cat VERSION)

GREEN=\033[0;32m
RED=\033[0;31m
WHITE=\033[1;37m

devdeps=$(shell pacman -Q base-devel pacman-contrib tar | grep -c "")

default:
	@echo "Checking build dependencies"
	@if [ $(devdeps) -eq 3 ]; then \
		echo "Dependencies installed. Proceeding..."; \
	else \
		echo "$(RED)Dependencies are not installed.$(WHITE) Please run $(GREEN) sudo make install$(WHITE)"; \
		exit 1; \
	fi

	@mkdir -p arch-repo
	@cp -r lib arch-repo/
	@cp $(cmd).sh arch-repo/$(cmd)
	@echo "Necessary directories created and files copied"

install:
	@echo "Installing build dependencies"
	@sudo pacman -S base-devel pacman-contrib tar
	@echo "$(GREEN)Build dependencies installed"

config:
	@echo "# Maintainer: Falah Ahmed <kpfalah99@gmail.com>" > arch-repo/PKGBUILD
	@echo "pkgname=$(pac)" >> arch-repo/PKGBUILD
	@echo "pkgver=$(VER)" >> arch-repo/PKGBUILD
	@echo "pkgrel=$(pkgrel + 1)" >> arch-repo/PKGBUILD
	@echo "pkgdesc='A script to automate organizing download files" >> arch-repo/PKGBUILD
	@echo "		You can utilize available options to organize your downloaded files" >> arch-repo/PKGBUILD
	@echo "		I'm planning to extend organizing criteria and to develop gui. A helping hand is always welcome." >> arch-repo/PKGBUILD
	@echo "		You can contact me at telegram: @chruxAdmin" >> arch-repo/PKGBUILD
	@echo "		github: @falahahmed'" >> arch-repo/PKGBUILD
	@echo "arch=('any')" >> arch-repo/PKGBUILD
	@echo "url='https://github.com/falahahmed/downganizer'" >> arch-repo/PKGBUILD
	@echo "license=('SKIP')" >> arch-repo/PKGBUILD
	@echo "depends=('inotify-tools>=3.22.6')" >> arch-repo/PKGBUILD
	@echo "source=($$pkgname-$$pkgver.tar.gz)" >> arch-repo/PKGBUILD
	@echo "md5sums=('SKIP')" >> arch-repo/PKGBUILD
	@echo "" >> arch-repo/PKGBUILD
	@echo "package() {" >> arch-repo/PKGBUILD
	@echo "  install -Dm755 $$srcdir/$$pkgname/$(cmd) $$pkgdir/usr/bin/$(cmd)" >> arch-repo/PKGBUILD
	@echo "  install -d $$pkgdir/usr/share/$$pkgname/lib" >> arch-repo/PKGBUILD
	@echo "  cp -r $$srcdir/$$pkgname/lib/* $$pkgdir/usr/share/$$pkgname/lib/" >> arch-repo/PKGBUILD
	@echo "}" >> arch-repo/PKGBUILD

build:
	# Building arch package
	@tar czvf $(pac)-$(VER).tar.gz arch-repo
	@mv $(pac)-$(VER).tar.gz arch-repo/
	@cd arch-repo && makepkg -si

transfer:
	@if [ ! -d "$(target_dir)" ]; then \
		mkdir -p $(target_dir); \
	fi
	@rm -f $(target_dir)/*.gz
	@rm -f $(target_dir)/*.db
	@rm -f $(target_dir)/*.files
	@echo "$(pkgrel + 1)" > pkgrel

clean:
	@rm -rf arch-repo/*
	@rm -f *.tar.gz