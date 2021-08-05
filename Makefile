all: clean render build

.PHONY: all

# Default
clean:
	@rm -rf bitmaps themes

render: bitmapper svg
	@cd bitmapper && make install render_modern render_original

build: bitmaps
	@cd builder && make setup build


# Specific platform build
unix: clean render bitmaps
	@cd builder && make setup build_unix

windows: clean render bitmaps
	@cd builder && make setup build_windows

# Bibata Modern
modern: clean render_modern build_modern

render_modern: bitmapper svg
	@cd bitmapper && make install render_modern

build_modern: bitmaps
	@cd builder && make setup build_modern


# Bibata Original
original:clean render_original build_original

render_original: bitmapper svg
	@cd bitmapper && make install render_original

build_original: bitmaps
	@cd builder && make setup build_original


# Installation
.ONESHELL:
SHELL:=/bin/bash

src = ./themes/Bibata-Zebra-*
local := ~/.icons
local_dest := $(local)/Bibata-Zebra-*

root := /usr/share/icons
root_dest := $(root)/Bibata-Zebra-*

install: themes
	@if [[ $EUID -ne 0 ]]; then
		@echo "> Installing 'Bibata-Zebra' cursors inside $(local)/..."
		@mkdir -p $(local)
		@cp -r $(src) $(local)/ && echo "> Installed!"
	@else
		@echo "> Installing 'Bibata-Zebra' cursors inside $(root)/..."
		@mkdir -p $(root)
		@sudo cp -r $(src) $(root)/ && echo "> Installed!"
	@fi

uninstall:
	@if [[ $EUID -ne 0 ]]; then
		@echo "> Removing 'Bibata-Zebra' cursors from '$(local)'..."
		@rm -rf $(local_dest)
	@else
		@echo "> Removing 'Bibata-Zebra' cursors from '$(root)'..."
		@sudo rm -rf $(root_dest)
	@fi

reinstall: uninstall install

# generates binaries
BIN_DIR = ../bin
prepare: bitmaps themes
	# Bitmaps
	@rm -rf bin && mkdir bin
	@cd bitmaps && zip -r $(BIN_DIR)/bitmaps.zip * && cd ..
	@cd themes
	@tar -czvf $(BIN_DIR)/Bibata-Zebra-Modern.tar.gz Bibata-Zebra-Modern
	@zip -r $(BIN_DIR)/Bibata-Zebra-Modern-Windows.zip Bibata-Zebra-Modern-Windows
	@tar -czvf $(BIN_DIR)/Bibata-Zebra-Original.tar.gz Bibata-Zebra-Original
	@zip -r $(BIN_DIR)/Bibata-Zebra-Original-Windows.zip Bibata-Zebra-Original-Windows
	@cd ..
