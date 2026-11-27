LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),x103f)

$(call add-radio-file,splash.img)
$(call add-radio-file,emmc_appsboot.mbn)

include $(call all-subdir-makefiles,$(LOCAL_PATH))

endif
