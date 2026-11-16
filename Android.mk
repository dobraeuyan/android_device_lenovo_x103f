LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),x103f)

$(call add-radio-file,splash.img)

include $(call all-subdir-makefiles,$(LOCAL_PATH))

endif
