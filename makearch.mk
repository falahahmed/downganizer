# Making the arch package from bash script

pac ?= $(shell cat PAC)
cmd=downganizer
pkgrel ?= $(shell cat pkgrel)

target_dir=/home/chrux/Documents/adekacciorg.github.io/man-pacs

VER ?= $(shell cat VERSION)

GREEN=\e[0;32m
RED=\e[0;31m
WHITE=\e[1;37m
REGULAR=\e[0m

devdeps=$(shell pacman -Q base-devel pacman-contrib tar | grep -c "")

default:
	@echo "Checking build dependencies"
	@if [ $(devdeps) -eq 3 ]; then \
		echo "Dependencies installed. Proceeding..."; \
	else \
		echo -e "$(RED)Dependencies are not installed.$(REGULAR) Please run $(GREEN) sudo make install$(WHITE)"; \
		exit 1; \
	fi

	@mkdir -p $(pac)
	@cp -r lib $(pac)/
	@cp $(cmd).sh $(pac)/$(cmd)
	@sed -i 's/PROD=false/PROD=true/' $(pac)/$(cmd) $(pac)/lib/*
	@echo "Necessary directories created and files copied"

install:
	@echo "Installing build dependencies"
	@sudo pacman -S base-devel pacman-contrib tar
	@echo -e "$(GREEN)Build dependencies installed"

config:
	@echo "CRITERIAS=[type month]" > $(pac)/options.conf
	@echo "DUP_METHODS=[rename overwrite]" >> $(pac)/options.conf

	@echo "Created $(pac)/etc/$(cmd)/options.conf"
	
	@echo "# Maintainer: Falah Ahmed <kpfalah99@gmail.com>" > $(pac)/PKGBUILD
	@echo "pkgname=$(pac)" >> $(pac)/PKGBUILD
	@echo "pkgver=$(VER)" >> $(pac)/PKGBUILD
	@echo "pkgrel=$(pkgrel)" >> $(pac)/PKGBUILD
	@echo "pkgdesc=A script to automate organizing download files" >> $(pac)/PKGBUILD
# 	@echo "		You can utilize available options to organize your downloaded files" >> $(pac)/PKGBUILD
# 	@echo "		I'm planning to extend organizing criteria and to develop gui. A helping hand is always welcome." >> $(pac)/PKGBUILD
# 	@echo "		You can contact me at telegram: @chruxAdmin" >> $(pac)/PKGBUILD
# 	@echo "		github: @falahahmed'" >> $(pac)/PKGBUILD
	@echo "arch=('any')" >> $(pac)/PKGBUILD
	@echo "url='https://github.com/falahahmed/downganizer'" >> $(pac)/PKGBUILD
	@echo "license=('SKIP')" >> $(pac)/PKGBUILD
	@echo "depends=('inotify-tools>=3.22.6')" >> $(pac)/PKGBUILD
	@printf '%s\n' 'source=($$''pkgname-$$''pkgver.tar.gz)' >> $(pac)/PKGBUILD
	@echo "md5sums=('SKIP')" >> $(pac)/PKGBUILD
	@echo "" >> $(pac)/PKGBUILD
	@echo "package() {" >> $(pac)/PKGBUILD
	@printf '%s\n' '  install -Dm755 $$srcdir/$$pkgname/$(cmd) $$pkgdir/usr/bin/$(cmd)' >> $(pac)/PKGBUILD
	@printf '%s\n' '  install -d $$pkgdir/usr/share/$$pkgname/lib' >> $(pac)/PKGBUILD
	@printf '%s\n' '  install -d $$pkgdir/etc/$$pkgname' >> $(pac)/PKGBUILD
	@printf '%s\n' '  cp $$srcdir/$$pkgname/options.conf $$pkgdir/etc/$$pkgname/' >> $(pac)/PKGBUILD
	@printf '%s\n' '  cp -r $$srcdir/$$pkgname/lib/* $$pkgdir/usr/share/$$pkgname/lib/' >> $(pac)/PKGBUILD
	@echo "}" >> $(pac)/PKGBUILD

	@echo "Created $(pac)/PKGBUILD"

build:
	# Building arch package
	@tar czvf $(pac)-$(VER).tar.gz $(pac)
	@mv $(pac)-$(VER).tar.gz $(pac)/
	@cd $(pac) && makepkg -si
	@echo -e "$(GREEN)Package built and installed successfully$(REGULAR)"

transfer:
	@if [ ! -d "$(target_dir)" ]; then \
		mkdir -p $(target_dir); \
	fi
	@rm -f $(target_dir)/*.gz
	@rm -f $(target_dir)/*.db
	@rm -f $(target_dir)/*.files
	@cp $(pac)/*.pkg.tar.zst $(target_dir)/
	@awk "BEGIN { print $(pkgrel) + 1}" > pkgrel
	@echo "Package transfered to man-pacs"

clean:
	@rm -rf $(pac)/*
	@rm -f *.tar.gz
	@echo "Cleaned up"