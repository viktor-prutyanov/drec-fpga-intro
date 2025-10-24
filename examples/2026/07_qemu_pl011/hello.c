#define UARTDR 0x9000000
 
void pl011_puts(const char *s) {
    while (*s) {
        *(volatile unsigned char *)UARTDR = *s;
        s++;
    }
}
 
void entry() {
    pl011_puts("Hello world!\n");
}