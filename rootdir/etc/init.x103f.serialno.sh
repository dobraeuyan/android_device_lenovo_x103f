#!/system/bin/sh

usr_flag=`cat /persist/serialno`
serialnum=`serialnoread`
case "$usr_flag" in
       0 | "")
                                echo "0123456789ABCDEF" > /sys/class/android_usb/android0/iSerial
                                ;;
       1)
                                echo $serialnum > /sys/class/android_usb/android0/iSerial
                                ;;
esac
