.DEFAULT_GOAL := all
include config.mk

ARCH_DIR := $(WORKING_DIR)/arch
X86_DIR := $(ARCH_DIR)/x86

JORUM_ARCHIVES :=

ifeq ($(TARGET_ARCH),x86_64)
include $(X86_DIR)/Makefile

LD_FLAGS += -T$(X86_DIR)/linker.ld
CC_FLAGS += -m64
JORUM_ARCHIVES += $(X86_ARCHIVE)

else ifeq ($(TARGET_ARCH),x86)
include $(X86_DIR)/Makefile

LD_FLAGS += -T$(X86_DIR)/linker.ld
CC_FLAGS += -m32
JORUM_ARCHIVES += $(X86_ARCHIVE)
else
  $(error "Unsupported TARGET_ARCH: $(TARGET_ARCH)")
endif

JORUM := $(WORKING_DIR)/jorum

all: $(JORUM)

%.o: %.S
	$(call compile_c,$<,$@)

%.o: %.c
	$(call compile_c,$<,$@)

$(JORUM): $(JORUM_ARCHIVES)
	$(call link_objs,$(JORUM_ARCHIVES),$@)

.PHONY: clean
clean: clean_arch
	$(call remove_at,$(JORUM))
