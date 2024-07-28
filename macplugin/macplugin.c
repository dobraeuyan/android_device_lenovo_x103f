#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define LOG_TAG "macplugin"
#include <log/log.h>

static const char WLAN_BDADDR_PATH[] = "/persist/wlan_mac.bin";

static int set_wlan_mac(void) {
    int fd;
    uint8_t mac_addr[6];
    uint8_t mac_addr_1[6];
    uint8_t mac_addr_2[6];
    uint8_t mac_addr_3[6];
    uint8_t mac_addr_4[6];
    int i;

    fd = open(WLAN_BDADDR_PATH, O_WRONLY | O_CREAT | O_EXCL, 0600);
    if (fd < 0) {
        if (errno != EEXIST) {
            return -1;
        }
        return 0;
    }

    ALOGI("Writing WLAN MAC file\n");

    for (i = 0; i < 6; i++) {
        mac_addr[i] = rand() % 256;
    }

    mac_addr[0] = 0x48;
    mac_addr[1] = 0x88;
    mac_addr[2] = 0xca;
    mac_addr[3] = 0x85;
    mac_addr[4] = 0x80;

    memcpy(mac_addr_1, mac_addr, 6);
    memcpy(mac_addr_2, mac_addr, 6);
    memcpy(mac_addr_3, mac_addr, 6);
    memcpy(mac_addr_4, mac_addr, 6);

    mac_addr_1[5] = 0x6f;
    mac_addr_2[5] = 0x70;
    mac_addr_3[5] = 0x71;
    mac_addr_4[5] = 0x72;

    write(fd, mac_addr_1, 6);
    write(fd, mac_addr_2, 6);
    write(fd, mac_addr_3, 6);
    write(fd, mac_addr_4, 6);
    close(fd);

    return 0;
}

int main(void) {
    srand(time(NULL));
    if (set_wlan_mac() != 0) {
        ALOGE("Failed to set WLAN MAC\n");
    }
    return 0;
}

