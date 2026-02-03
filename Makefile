.DEFAULT_GOAL := all
include toolchain.mk

CONFIG_H := $(WORKING_DIR)/config.h

ISO_DIR := $(WORKING_DIR)/iso
BOOT_DIR := $(ISO_DIR)/boot
BOOT_JORUM := $(BOOT_DIR)/jorum.elf

ARCH_DIR := $(WORKING_DIR)/arch
X86_DIR := $(ARCH_DIR)/x86

KERNEL_DIR := $(WORKING_DIR)/kernel

INCLUDE_DIR := $(WORKING_DIR)/include
CC_FLAGS += -I$(WORKING_DIR) -I$(INCLUDE_DIR) -g3 -mno-red-zone

include $(KERNEL_DIR)/Makefile

ARCH_ARCHIVE :=

ifeq ($(TARGET_ARCH),x86_64)
include $(X86_DIR)/Makefile

LD_FLAGS += -m64 -T$(X86_LINK)
CC_FLAGS += -m64
ARCH_ARCHIVE := $(X86_ARCHIVE)

else ifeq ($(TARGET_ARCH),i386)
include $(X86_DIR)/Makefile

LD_FLAGS += -m32 -T$(X86_LINK)
CC_FLAGS += -m32
ARCH_ARCHIVE := $(X86_ARCHIVE)
else
  $(error "Unsupported TARGET_ARCH: $(TARGET_ARCH)")
endif

JORUM_ARCHIVES := $(ARCH_ARCHIVE) $(KERNEL_ARCHIVE) $(ARCH_ARCHIVE)

JORUM := $(WORKING_DIR)/jorum
JORUM_ISO := $(WORKING_DIR)/jorum.iso

all: $(JORUM) $(JORUM_ISO)

%.oc: %.c
	$(call compile_c,$<,$@)

%.os: %.S
	$(call compile_c,$<,$@)

$(JORUM): $(JORUM_ARCHIVES)
	$(call link_objs, $(JORUM_ARCHIVES),$@)

$(BOOT_JORUM): $(JORUM)
	$(call copy_file,$<,$@)

$(JORUM_ISO): $(JORUM) $(BOOT_JORUM)
	$(call notice,GRUB ,$@)
	$(Q)$(GRUB) -o $@ $(ISO_DIR)

.PHONY: clean
clean: clean_arch clean_kernel
	$(call remove_at,$(JORUM))
