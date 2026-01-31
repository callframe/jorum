X86_ARCHIVE := $(X86_DIR)/libx86.a
X86_BOOT_DIR := $(X86_DIR)/boot

X86_SOURCES :=
include $(X86_BOOT_DIR)/Makefile

X86_OBJECTS := $(call c2objs,$(X86_SOURCES))
X86_OBJECTS += $(call asm2objs,$(X86_SOURCES))

$(X86_ARCHIVE): $(X86_OBJECTS)
	$(call archive_objs,$(X86_OBJECTS),$@)

.PHONY: clean_arch
clean_arch:
	$(call remove_at,$(X86_ARCHIVE))
	$(call remove_at,$(X86_OBJECTS))