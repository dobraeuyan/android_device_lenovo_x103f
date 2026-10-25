$(call inherit-product, device/qcom/msm8909-common/msm8909.mk)

$(call inherit-product-if-exists, vendor/lenovo/x103f/x103f-vendor.mk)

TARGET_SCREEN_HEIGHT := 800
TARGET_SCREEN_WIDTH := 1280

$(call inherit-product-if-exists, frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk)

DEVICE_PACKAGE_OVERLAYS += device/lenovo/x103f/overlay

PRODUCT_PACKAGES += \
    X103OverlayFrameworksRes \
    X103OverlaySystemUI

PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service \
    keystore.msm8909

PRODUCT_COPY_FILES += \
    device/lenovo/x103f/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom \
    device/lenovo/x103f/rootdir/etc/init.device.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.device.rc
