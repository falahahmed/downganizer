# Making the apt/pacman package from bash script

pac ?= $(shell cat PAC)
sys ?= $(shell cat SYS)
cmd=downganizer

target_dir=/home/chrux/Documents/Web/adekacciorg.github.io/lin-packs/pool/main/d/$(pac)

VER ?= $(shell cat VERSION)

GREEN=\033[0;32m
RED=\033[0;31m
WHITE=\033[1;37m

devdeps=$(shell apt list build-essential debhelper dh-make devscripts reprepro 2>/dev/null | grep -c "installed")

default:
	@if [ "$(sys)" = "deb" ]; then \
		make -f makedeb.mk pac="$(pac)" 2>&1 | grep -v '^make\[1\]' ; \
	elif [ "$(sys)" = "arch" ]; then \
		make -f makearch.mk pac="$(pac)" 2>&1 | grep -v '^make\[1\]' ; \
	else \
		echo "$(RED)Invalid SYS value in SYS file. Please set it to 'deb' or 'arch'$(WHITE)"; \
		exit 1; \
	fi

	@echo "$(VER)" > VERSION
	@echo "$(pac)" > PAC
	@echo "$(sys)" > SYS

install:
	@if [ "$(sys)" = "deb" ]; then \
		make -f makedeb.mk install 2>&1 | grep -v '^make\[1\]' ; \
	elif [ "$(sys)" = "arch" ]; then \
		make -f makearch.mk install 2>&1 | grep -v '^make\[1\]' ; \
	else \
		echo "$(RED)Invalid SYS value in SYS file. Please set it to 'deb' or 'arch'$(WHITE)"; \
		exit 1; \
	fi

config:
	@if [ "$(sys)" = "deb" ]; then \
		make -f makedeb.mk config 2>&1 | grep -v '^make\[1\]' ; \
	elif [ "$(sys)" = "arch" ]; then \
		make -f makearch.mk config 2>&1 | grep -v '^make\[1\]' ; \
	else \
		echo "$(RED)Invalid SYS value in SYS file. Please set it to 'deb' or 'arch'$(WHITE)"; \
		exit 1; \
	fi

build: 
	@if [ "$(sys)" = "deb" ]; then \
		make -f makedeb.mk build 2>&1 | grep -v '^make\[1\]' ; \
	elif [ "$(sys)" = "arch" ]; then \
		make -f makearch.mk build 2>&1 | grep -v '^make\[1\]' ; \
	else \
		echo "$(RED)Invalid SYS value in SYS file. Please set it to 'deb' or 'arch'$(WHITE)"; \
		exit 1; \
	fi
	
transfer:
	@if [ "$(sys)" = "deb" ]; then \
		make -f makedeb.mk transfer 2>&1 | grep -v '^make\[1\]' ; \
	elif [ "$(sys)" = "arch" ]; then \
		make -f makearch.mk transfer 2>&1 | grep -v '^make\[1\]' ; \
	else \
		echo "$(RED)Invalid SYS value in SYS file. Please set it to 'deb' or 'arch'$(WHITE)"; \
		exit 1; \
	fi

clean:
	@if [ "$(sys)" = "deb" ]; then \
		make -f makedeb.mk clean 2>&1 | grep -v '^make\[1\]' ; \
	elif [ "$(sys)" = "arch" ]; then \
		make -f makearch.mk clean 2>&1 | grep -v '^make\[1\]' ; \
	else \
		echo "$(RED)Invalid SYS value in SYS file. Please set it to 'deb' or 'arch'$(WHITE)"; \
		exit 1; \
	fi