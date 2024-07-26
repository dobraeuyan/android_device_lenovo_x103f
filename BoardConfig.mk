DEVICE_PATH := device/lenovo/x103f

# Arch
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI  := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a7

BOARD_VENDOR := lenovo

# Audio
BOARD_USES_ALSA_AUDIO := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

# Bluetooth
BOARD_HAVE_BLUETOOTH_QCOM := true
QCOM_BT_USE_BTNV := true
BLUETOOTH_HCI_USE_MCT := true

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth

# Board
TARGET_BOARD_PLATFORM := msm8909
TARGET_BOARD_PLATFORM_GPU := qcom-adreno304

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8909
TARGET_NO_BOOTLOADER := true

# Camera
USE_CAMERA_STUB := true
TARGET_HAS_LEGACY_CAMERA_HAL1 := true

# Display
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
TARGET_HARDWARE_3D := false
TARGET_HAVE_HDMI_OUT := false
TARGET_USES_C2D_COMPOSITION := false
TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_QCOM_BSP := true
TARGET_CONTINUOUS_SPLASH_ENABLED := true
USE_OPENGL_RENDERER := true

GET_FRAMEBUFFER_FORMAT_FROM_HWC := true

MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024

OVERRIDE_RS_DRIVER := libRSDriver_adreno.so

# EGL
BOARD_EGL_CFG := $(DEVICE_PATH)/configs/egl.cfg

# Encryption
TARGET_HW_DISK_ENCRYPTION := true
TARGET_HW_KEYMASTER_V03 := true

# Filesystem
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
BOARD_USERDATAIMAGE_PARTITION_SIZE := 11811160064

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4

# FM Radio
TARGET_QCOM_NO_FM_FIRMWARE := true
BOARD_HAVE_QCOM_FM := true
AUDIO_FEATURE_ENABLED_FM_POWER_OPT := true

# Init
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/
TARGET_INIT_VENDOR_LIB := libinit_x103f
TARGET_RECOVERY_DEVICE_MODULES := libinit_x103f

# Kernel
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=x103f ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1
BOARD_KERNEL_IMAGE_NAME := zImage
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_SEPARATED_DT := true
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x02000000 --tags_offset 0x01e00000
TARGET_KERNEL_ARCH := arm
TARGET_KERNEL_SOURCE := kernel/lenovo/x103f
TARGET_KERNEL_CONFIG := lineage_x103f_defconfig

# Keymaster
TARGET_PROVIDES_KEYMASTER := true

# Lights
TARGET_PROVIDES_LIBLIGHT := true

# Media
TARGET_USES_MEDIA_EXTENSIONS := true

# Memory Config
MALLOC_SVELTE := true

# OTA
TARGET_OTA_ASSERT_DEVICE := msm8909,x103f,TB-X103F

# Peripheral manager
TARGET_PER_MGR_ENABLED := true

# Power
TARGET_POWERHAL_VARIANT := qcom

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Qualcomm
BOARD_USES_QCOM_HARDWARE := true

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/recovery.fstab

# SELinux
include device/qcom/sepolicy/sepolicy.mk

BOARD_SEPOLICY_DIRS += \
    $(DEVICE_PATH)/sepolicy

# Widevine
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3

# Wifi
BOARD_WLAN_DEVICE		:= qcwcn
BOARD_WPA_SUPPLICANT_DRIVER	:= NL80211
WPA_SUPPLICANT_VERSION		:= VER_0_8_X
WIFI_DRIVER_FW_PATH_STA		:= "sta"
WIFI_DRIVER_FW_PATH_AP		:= "ap"
TARGET_WCNSS_MAC_PREFIX		:= e8bba8

# inherit from the proprietary version
-include vendor/lenovo/x103f/BoardConfigVendor.mk
