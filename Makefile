.PHONY: all app install clean

BUILD_DIR := .build/release
APP_NAME := Scratchpad
APP_DIR  := build/$(APP_NAME).app
INSTALL  := /Applications/$(APP_NAME).app

all: app

$(BUILD_DIR)/$(APP_NAME):
	swift build -c release

build/AppIcon.icns:
	python3 gen-icon.py

$(APP_DIR): $(BUILD_DIR)/$(APP_NAME) build/AppIcon.icns
	@mkdir -p $(APP_DIR)/Contents/MacOS
	@mkdir -p $(APP_DIR)/Contents/Resources
	cp $(BUILD_DIR)/$(APP_NAME) $(APP_DIR)/Contents/MacOS/
	cp Info.plist $(APP_DIR)/Contents/
	cp build/AppIcon.icns $(APP_DIR)/Contents/Resources/

app: $(APP_DIR)
	@echo "✅ $(APP_NAME).app created at build/"

install: $(APP_DIR)
	@rm -rf $(INSTALL)
	cp -R $(APP_DIR) $(INSTALL)
	@echo "✅ Installed to $(INSTALL)"

clean:
	rm -rf build
	swift package clean
