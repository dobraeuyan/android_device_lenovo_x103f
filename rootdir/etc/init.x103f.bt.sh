#!/system/bin/sh

#Read the arguments passed to the script
config="$1"

BLUETOOTH_SLEEP_PATH=/proc/bluetooth/sleep/proto
LOG_TAG="qcom-bluetooth"
LOG_NAME="${0}:"

hciattach_pid=""

loge ()
{
  /system/bin/log -t $LOG_TAG -p e "$LOG_NAME $@"
}

logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

failed ()
{
  loge "$1: exit code $2"
  exit $2
}

program_bdaddr ()
{
  /system/bin/btnvtool -O
  logi "Bluetooth Address programmed successfully"
}

#
# enable bluetooth profiles dynamically
#
config_bt ()
{
  baseband=`getprop ro.baseband`
  target=`getprop ro.board.platform`
  if [ -f /sys/devices/soc0/soc_id ]; then
    soc_hwid=`cat /sys/devices/soc0/soc_id`
  else
    soc_hwid=`cat /sys/devices/system/soc/soc0/id`
  fi
  btsoc=`getprop qcom.bluetooth.soc`

  if ls /sys/class/leds/bt; then
    chmod 0666 /sys/class/leds/bt/brightness
  fi

if [ -f /system/etc/bluetooth/stack.conf ]; then
stack=`cat /system/etc/bluetooth/stack.conf`
fi

case "$stack" in
    "bluez")
	   logi "Bluetooth stack is $stack"
	   setprop ro.qc.bluetooth.stack $stack
	   reason=`getprop vold.decrypt`
	   case "$reason" in
	       "trigger_restart_framework")
	           start dbus
	           ;;
	   esac
        ;;
    *)
	   logi "Bluetooth stack is Bluedroid"
        ;;
esac

}

start_hciattach ()
{
  /system/bin/hciattach -n $BTS_DEVICE $BTS_TYPE $BTS_BAUD &
  hciattach_pid=$!
  logi "start_hciattach: pid = $hciattach_pid"
  echo 1 > $BLUETOOTH_SLEEP_PATH
}

kill_hciattach ()
{
  echo 0 > $BLUETOOTH_SLEEP_PATH
  logi "kill_hciattach: pid = $hciattach_pid"
  ## careful not to kill zero or null!
  kill -TERM $hciattach_pid
  # this shell doesn't exit now -- wait returns for normal exit
}

logi "init.qcom.bt.sh config = $config"
case "$config" in
    "onboot")
        program_bdaddr
        config_bt
        exit 0
        ;;
    *)
        ;;
esac

# mimic hciattach options parsing -- maybe a waste of effort
USAGE="hciattach [-n] [-p] [-b] [-t timeout] [-s initial_speed] <tty> <type | id> [speed] [flow|noflow] [bdaddr]"

while getopts "blnpt:s:" f
do
  case $f in
  b | l | n | p)  opt_flags="$opt_flags -$f" ;;
  t)      timeout=$OPTARG;;
  s)      initial_speed=$OPTARG;;
  \?)     echo $USAGE; exit 1;;
  esac
done
shift $(($OPTIND-1))

# Note that "hci_qcomm_init -e" prints expressions to set the shell variables
# BTS_DEVICE, BTS_TYPE, BTS_BAUD, and BTS_ADDRESS.

#Selectively Disable sleep
BOARD=`getprop ro.board.platform`
STACK=`getprop ro.qc.bluetooth.stack`

# BR/EDR & LE power class configurations
POWER_CLASS=`getprop qcom.bt.dev_power_class`
LE_POWER_CLASS=`getprop qcom.bt.le_dev_pwr_class`

#find the transport type
TRANSPORT=`getprop ro.qualcomm.bt.hci_transport`
logi "Transport : $TRANSPORT"
case $STACK in
    "bluez")
       logi "** Bluez stack **"
    ;;
    *)
       logi "** Bluedroid stack **"
       setprop bluetooth.status off
    ;;
esac

case $POWER_CLASS in
  1) PWR_CLASS="-p 0" ;
     logi "Power Class: 1";;
  2) PWR_CLASS="-p 1" ;
     logi "Power Class: 2";;
  3) PWR_CLASS="-p 2" ;
     logi "Power Class: CUSTOM";;
  *) PWR_CLASS="";
     logi "Power Class: Ignored. Default(1) used (1-CLASS1/2-CLASS2/3-CUSTOM)";
     logi "Power Class: To override, Before turning BT ON; setprop qcom.bt.dev_power_class <1 or 2 or 3>";;
esac

case $LE_POWER_CLASS in
  1) LE_PWR_CLASS="-P 0" ;
     logi "LE Power Class: 1";;
  2) LE_PWR_CLASS="-P 1" ;
     logi "LE Power Class: 2";;
  3) LE_PWR_CLASS="-P 2" ;
     logi "LE Power Class: CUSTOM";;
  *) LE_PWR_CLASS="-P 1";
     logi "LE Power Class: Ignored. Default(2) used (1-CLASS1/2-CLASS2/3-CUSTOM)";
     logi "LE Power Class: To override, Before turning BT ON; setprop qcom.bt.le_dev_pwr_class <1 or 2 or 3>";;
esac

eval $(/system/bin/hci_qcomm_init -e $PWR_CLASS $LE_PWR_CLASS && echo "exit_code_hci_qcomm_init=0" || echo "exit_code_hci_qcomm_init=1")

case $exit_code_hci_qcomm_init in
  0) logi "Bluetooth QSoC firmware download succeeded, $BTS_DEVICE $BTS_TYPE $BTS_BAUD $BTS_ADDRESS";;
  *) failed "Bluetooth QSoC firmware download failed" $exit_code_hci_qcomm_init;
     case $STACK in
         "bluez")
            logi "** Bluez stack **"
         ;;
         *)
            logi "** Bluedroid stack **"
            setprop bluetooth.status off
        ;;
     esac

     exit $exit_code_hci_qcomm_init;;
esac

# init does SIGTERM on ctl.stop for service
trap "kill_hciattach" TERM INT

case $TRANSPORT in
    "smd")
       case $STACK in
           "bluez")
              logi "** Bluez stack **"
              echo 1 > /sys/module/hci_smd/parameters/hcismd_set
           ;;
           *)
              logi "** Bluedroid stack **"
              setprop bluetooth.status on
           ;;
       esac
     ;;
     *)
        logi "start hciattach"
        start_hciattach
        case $STACK in
            "bluez")
               logi "Bluetooth is turning On with Bluez stack "
            ;;
            *)
               logi "** Bluedroid stack **"
               setprop bluetooth.status on
            ;;
        esac

        wait $hciattach_pid
        logi "Bluetooth stopped"
     ;;
esac

exit 0
