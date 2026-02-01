KERNEL_ARCHIVE := $(KERNEL_DIR)/libkernel.a

KERNEL_SOURCES := \
	$(KERNEL_DIR)/kernel.c

KERNEL_OBJECTS := $(call c2objs,$(KERNEL_SOURCES))
KERNEL_OBJECTS += $(call asm2objs,$(KERNEL_SOURCES))

$(KERNEL_ARCHIVE): $(KERNEL_OBJECTS)
	$(call archive_objs,$(KERNEL_OBJECTS),$@)

.PHONY: clean_kernel
clean_kernel:
	$(call remove_at,$(KERNEL_ARCHIVE))
	$(call remove_at,$(KERNEL_OBJECTS))