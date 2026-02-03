X86_LINK_IN := $(X86_DIR)/linker.ld.S
X86_LINK := $(X86_DIR)/linker.ld

X86_ARCHIVE := $(X86_DIR)/libx86.a
X86_BOOT_DIR := $(X86_DIR)/boot
X86_MEM_DIR := $(X86_DIR)/mem

X86_SOURCES :=
include $(X86_BOOT_DIR)/Makefile
include $(X86_MEM_DIR)/Makefile

X86_OBJECTS := $(call c2objs,$(X86_SOURCES))
X86_OBJECTS += $(call asm2objs,$(X86_SOURCES))

$(X86_ARCHIVE): $(X86_LINK) $(X86_OBJECTS) $(CONFIG_H)
	$(call archive_objs,$(X86_OBJECTS),$@)

$(X86_LINK): $(X86_LINK_IN) $(CONFIG_H)
	$(call preprocess_file,$<,$@)

.PHONY: clean_arch
clean_arch:
	$(call remove_at,$(X86_ARCHIVE))
	$(call remove_at,$(X86_OBJECTS))
	$(call remove_at,$(X86_LINK))