typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

#define OUT_ADDR ((uint8_t *)0x20)

void main() {
    uint32_t first = 0, second = 1, next, i = 0;

    for (i = 0; i != 12; i++) {
        next = first + second;
        *(volatile uint32_t *)OUT_ADDR = next;
        first = second;
        second = next;
    }
}
