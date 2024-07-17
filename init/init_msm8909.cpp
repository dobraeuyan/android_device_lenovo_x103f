#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

#include <android-base/properties.h>
#include <android-base/file.h>
#include <android-base/strings.h>

#include "vendor_init.h"
#include "property_service.h"
#include "log.h"
#include "util.h"

using android::base::GetProperty;
using android::base::ReadFileToString;
using android::base::Trim;
using android::init::property_set;

__attribute__ ((weak))
void init_target_properties()
{
}

static void init_alarm_boot_properties()
{
    char const *boot_reason_file = "/proc/sys/kernel/boot_reason";
    std::string boot_reason;
    std::string tmp = GetProperty("ro.boot.alarmboot","");

    if (ReadFileToString(boot_reason_file, &boot_reason)) {
        if (Trim(boot_reason) == "3" || tmp == "true")
            property_set("ro.alarm_boot", "true");
        else
            property_set("ro.alarm_boot", "false");
    }
}

void property_override(char const prop[], char const value[])
{
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void property_override_dual(char const system_prop[], char const vendor_prop[], char const value[])
{
    property_override(system_prop, value);
    property_override(vendor_prop, value);
}

void set_sn()
{
    std::string usr_flag;
    std::string serialnum;
    
    if (!ReadFileToString("/persist/serialno", &usr_flag)) {
        LOG(ERROR) << "Failed to read /persist/serialno";
        usr_flag = "";
    }
    
    usr_flag = Trim(usr_flag);
    
    FILE *fp = popen("serialnoread", "r");
    if (fp != nullptr) {
        char buffer[128];
        if (fgets(buffer, sizeof(buffer), fp) != nullptr) {
            serialnum = Trim(buffer);
        }
        pclose(fp);
    }
    
    if (usr_flag == "0" || usr_flag.empty()) {
        property_override("ro.serialno", "0123456789ABCDEF");
    } else if (usr_flag == "1" && !serialnum.empty()) {
        property_override("ro.serialno", serialnum.c_str());
    }
}

void vendor_load_properties()
{
    set_sn();
    init_alarm_boot_properties();
}
