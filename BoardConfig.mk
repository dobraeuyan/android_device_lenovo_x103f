# Copyright (C) 2011 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_PATH := device/lenovo/x103f

# Arch
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI  := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a7

# Audio
BOARD_USES_ALSA_AUDIO := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
AUDIO_FEATURE_ENABLED_DS2_DOLBY_DAP := true
AUDIO_FEATURE_ENABLED_FM_POWER_OPT := true
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

#Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
BLUETOOTH_HCI_USE_MCT := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth

# Board
TARGET_BOARD_PLATFORM := msm8909
TARGET_BOARD_PLATFORM_GPU := qcom-adreno304

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8909
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# Camera
USE_CAMERA_STUB := true

# Cryptfs_hw
TARGET_CRYPTFS_HW_PATH := vendor/qcom/opensource/cryptfs_hw

# Dexpreopt
#ifeq ($(HOST_OS),linux)
#  ifeq ($(WITH_DEXPREOPT),)
#    ifeq ($(TARGET_BUILD_VARIANT),user)
#               WITH_DEXPREOPT := true
#               DEX_PREOPT_DEFAULT := true
#               WITH_DEXPREOPT_PIC := true
#    endif
#  endif
#endif

# Display
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_HARDWARE_3D := false
TARGET_HAVE_HDMI_OUT := false
TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_QCOM_BSP := true
TARGET_USES_OVERLAY := true
TARGET_USES_PCI_RCS := true

GET_FRAMEBUFFER_FORMAT_FROM_HWC := false

MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024

# EGL
BOARD_EGL_CFG := $(DEVICE_PATH)/configs/egl.cfg

# Encryption
TARGET_HW_DISK_ENCRYPTION := true
TARGET_HW_KEYMASTER_V03 := true

# Filesystem
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x01000000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x01000000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
BOARD_USERDATAIMAGE_PARTITION_SIZE := 11811160064
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_FLASH_BLOCK_SIZE := 131072

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4

# FM Radio
BOARD_HAVE_QCOM_FM := true
TARGET_QCOM_NO_FM_FIRMWARE := true

# GPS
TARGET_NO_RPC := true

# Init
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

# Kernel
TARGET_KERNEL_SOURCE := kernel/lenovo/x103f
TARGET_KERNEL_CONFIG := lineage_x103f_defconfig
TARGET_KERNEL_APPEND_DTB := true

BOARD_KERNEL_BASE        := 0x80000000
BOARD_KERNEL_PAGESIZE    := 2048
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk androidboot.selinux=permissive
BOARD_KERNEL_SEPARATED_DT := true

# Memory Config
MALLOC_SVELTE := true

# OTA
TARGET_OTA_ASSERT_DEVICE := msm8909,x103f

# Peripheral manager
TARGET_PER_MGR_ENABLED := true

# Platform
BOOTLOADER_PLATFORM := msm8909

# Protobuf
PROTOBUF_SUPPORTED := false

# Qualcomm
BOARD_USES_QCOM_HARDWARE := true

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/recovery.fstab

# RIL
FEATURE_QCRIL_UIM_SAP_SERVER_MODE := true

# SELinux
include device/qcom/sepolicy/sepolicy.mk

# Sensors
USE_SENSOR_MULTI_HAL := true

# Widevine
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3

#WiFi
BOARD_WLAN_DEVICE                := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
WPA_SUPPLICANT_VERSION           := VER_0_8_X
WIFI_DRIVER_MODULE_PATH          := /system/lib/modules/wlan.ko
WIFI_DRIVER_MODULE_NAME          := wlan
WIFI_DRIVER_FW_PATH_STA          := "sta"
WIFI_DRIVER_FW_PATH_AP           := "ap"

# inherit from the proprietary version
-include vendor/htc/a16/BoardConfigVendor.mk
