ARCHS = armv7 armv7s arm64
TARGET = iphone:clang:11.2:10.0

include theos/makefiles/common.mk

FRAMEWORK_NAME = astSetup
$(FRAMEWORK_NAME)_FILES = $(wildcard source/*.mm source/*.m source/ChildViewControllers/*.m)
$(FRAMEWORK_NAME)_INSTALL_PATH = /Library/Frameworks
$(FRAMEWORK_NAME)_CFLAGS += -fobjc-arc -I$(THEOS_PROJECT_DIR)/source

include $(THEOS_MAKE_PATH)/framework.mk
