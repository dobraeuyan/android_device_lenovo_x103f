#!/system/bin/sh

target=`getprop ro.board.platform`
case "$target" in
    "msm8909")

        if [ -f /sys/devices/soc0/soc_id ]; then
           soc_id=`cat /sys/devices/soc0/soc_id`
        else
           soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi

	#Set mmcblk0 read_ahead value for 8909_512 target
        ProductName=`getprop ro.product.name`
	if [ "$ProductName" == "msm8909_512" ]; then
		echo 128 > /sys/block/mmcblk0/queue/read_ahead_kb
	fi

        #Enable adaptive LMK and set vmpressure_file_min
        ProductName=`getprop ro.product.name`
    # Modified by sunyaxi to fix product name issue (A6505_M) A6505M-319 20160818 begin
	if [ "$ProductName" == "msm8909" ] || [ "$ProductName" == "msm8909_LMT" ] || [ "$ProductName" == "TB-X103F" ]; then
    # Modified by sunyaxi to fix product name issue (A6505_M) A6505M-319 20160818 end
		echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
		echo 53059 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
	elif [ "$ProductName" == "msm8909_512" ] || [ "$ProductName" == "msm8909w" ]; then
		echo "8192,11264,14336,17408,20480,26624" > /sys/module/lowmemorykiller/parameters/minfree
		echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
		echo 32768 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
	fi

	if [ "$ProductName" != "msm8909w" ]; then
		# HMP scheduler settings for 8909 similiar to 8916
		echo 3 > /proc/sys/kernel/sched_window_stats_policy
		echo 3 > /proc/sys/kernel/sched_ravg_hist_size

		# HMP Task packing settings for 8909 similiar to 8916
		echo 20 > /proc/sys/kernel/sched_small_task
		echo 30 > /proc/sys/kernel/sched_mostly_idle_load
		echo 3 > /proc/sys/kernel/sched_mostly_idle_nr_run
	fi

        # disable thermal core_control to update scaling_min_freq
        echo 0 > /sys/module/msm_thermal/core_control/enabled
        echo 1 > /sys/devices/system/cpu/cpu0/online
        if [ "$ProductName" == "msm8909w" ]; then
             echo 1 > /sys/devices/system/cpu/cpu1/online
        fi

	if [ "$ProductName" == "msm8909w" ]; then
		echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		echo "performance" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
		echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
		echo 800000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
		echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
		echo 800000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
		#Below entries are to set the GPU frequency and DCVS governor
		echo 200000000 > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
		echo 200000000 > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
		echo performance > /sys/class/kgsl/kgsl-3d0/devfreq/governor
	else
		echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	fi

        # enable thermal core_control now
	if [ "$ProductName" != "msm8909w" ]; then
		echo 1 > /sys/module/msm_thermal/core_control/enabled
	fi

        echo "30000 1094400:50000" > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
        echo 90 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
        echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
        echo 998400 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
        echo 0 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
        echo "1 800000:85 998400:90 1094400:80" > /sys/devices/system/cpu/cpufreq/interactive/target_loads
        echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
        echo 50000 > /sys/devices/system/cpu/cpufreq/interactive/sampling_down_factor

	if [ "$ProductName" == "msm8909w" ]; then
		# Post boot, have cpu0 and cpu1 online. Make all other cores go offline
		echo 0 > /sys/devices/system/cpu/cpu2/online
		echo 0 > /sys/devices/system/cpu/cpu3/online
	else
		# Bring up all cores online
		echo 1 > /sys/devices/system/cpu/cpu1/online
		echo 1 > /sys/devices/system/cpu/cpu2/online
		echo 1 > /sys/devices/system/cpu/cpu3/online
	fi

	echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled

	# Enable core control
	if [ "$ProductName" != "msm8909w" ]; then
		insmod /system/lib/modules/core_ctl.ko
		echo 2 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
		max_freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq`
		min_freq=800000
		echo $((min_freq*100 / max_freq)) $((min_freq*100 / max_freq)) $((66*1000000 / max_freq)) \
		$((55*1000000 / max_freq)) > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
		echo $((33*1000000 / max_freq)) > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
		echo 100 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
	fi

        # Apply governor settings for 8909
	for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
	do
		echo "bw_hwmon" > $devfreq_gov
		for cpu_bimc_bw_step in /sys/class/devfreq/qcom,cpubw*/bw_hwmon/bw_step
		do
			echo 60 > $cpu_bimc_bw_step
		done
		for cpu_guard_band_mbps in /sys/class/devfreq/qcom,cpubw*/bw_hwmon/guard_band_mbps
		do
			echo 30 > $cpu_guard_band_mbps
		done
	done

	for gpu_bimc_io_percent in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/io_percent
	do
		echo 40 > $gpu_bimc_io_percent
	done
	for gpu_bimc_bw_step in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/bw_step
	do
		echo 60 > $gpu_bimc_bw_step
	done
	for gpu_bimc_guard_band_mbps in /sys/class/devfreq/qcom,gpubw*/bw_hwmon/guard_band_mbps
	do
		echo 30 > $gpu_bimc_guard_band_mbps
	done
	;;
esac

chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
chown -h system /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy

emmc_boot=`getprop ro.boot.emmc`
case "$emmc_boot"
    in "true")
        chown -h system /sys/devices/platform/rs300000a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300000a7.65536/sync_sts
        chown -h system /sys/devices/platform/rs300100a7.65536/force_sync
        chown -h system /sys/devices/platform/rs300100a7.65536/sync_sts
    ;;
esac

# Post-setup services
case "$target" in
    "msm8909")
	start perfd
    ;;
esac

# WantJoin co. ltd add
ProductName=`getprop ro.product.name`
if [ "$ProductName" == "TB-X103F" ]; then
    PACKFLTMOD="/system/lib/modules/packfilter.ko"
    if [ -f "$PACKFLTMOD" ]; then
        insmod "$PACKFLTMOD"
    fi
fi
# WantJoin co. ltd end
