#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include "cmds.h"

int main() {
    int old = -1, new = -1;

    int fd = open("/dev/hello", O_RDWR);
    if (fd < 0) {
        fprintf(stderr, "Failed to open device\n");
        return -1;
    }
    ioctl(fd, GET_NUM, &old);
    ioctl(fd, INC_NUM);
    ioctl(fd, GET_NUM, &new);
    printf("%d -> %d\n", old, new);

    return 0;
}
