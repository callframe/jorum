.DEFAULT_GOAL := all
include toolchain.mk

ISO_DIR := $(WORKING_DIR)/iso
BOOT_DIR := $(ISO_DIR)/boot
BOOT_JORUM := $(BOOT_DIR)/jorum

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
JORUM_ISO := $(WORKING_DIR)/jorum.iso

all: $(JORUM) $(JORUM_ISO)

%.o: %.S
	$(call compile_c,$<,$@)

%.o: %.c
	$(call compile_c,$<,$@)

$(JORUM): $(JORUM_ARCHIVES)
	$(call link_objs,$(JORUM_ARCHIVES),$@)

$(BOOT_JORUM): $(JORUM)
	$(call copy_file,$<,$@)

$(JORUM_ISO): $(JORUM) $(BOOT_JORUM)
	$(call notice,GRUB ,$@)
	$(Q)$(GRUB) -o $@ $(ISO_DIR)

ifneq ($(QEMU),)
.PHONY: run
run: $(JORUM_ISO)
	$(call notice,QEMU ,$<)
	$(Q)$(QEMU) $(QEMU_FLAGS) -cdrom $<
	
endif

.PHONY: clean
clean: clean_arch
	$(call remove_at,$(JORUM))
