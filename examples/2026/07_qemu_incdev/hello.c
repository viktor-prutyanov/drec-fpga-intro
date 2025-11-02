#define UARTDR 0x9000000
#define INCDEV 0x9008000

typedef unsigned char uint8_t;
typedef long unsigned int uint64_t;

void pl011_putc(const uint8_t c) {
    *(volatile uint8_t *)UARTDR = c;
}

void incdev_set(const uint64_t n) {
    *(volatile uint64_t *)INCDEV = n;
}

uint64_t incdev_get() {
    return *(volatile uint64_t *)INCDEV;
}

void entry() {
    incdev_set('A');
    for (int i = 0; i < 8; i++)
        pl011_putc(incdev_get());
    pl011_putc('\n');
}
