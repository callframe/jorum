.DEFAULT_GOAL := all
include config.mk

all: $(BUILD_DIR)

$(BUILD_DIR):
	$(call make_dir,$@)