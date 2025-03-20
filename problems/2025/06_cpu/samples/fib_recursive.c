typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

#define OUT_ADDR ((uint8_t *)0x20)

uint32_t fib(uint32_t n) {
    if (n < 3)
        return n;
    else
        return fib(n-1) + fib(n-2);
}

void main() {
    *(volatile uint32_t *)OUT_ADDR = fib(12);
}