X86_CC_FLAGS =

X86_SOURCES += \
	$(X86_BOOT_DIR)/boot.S

%.o: %.S
	$(call compile_c,$<,$@,$(X86_CC_FLAGS))

%.o: %.c
	$(call compile_c,$<,$@,$(X86_CC_FLAGS))
