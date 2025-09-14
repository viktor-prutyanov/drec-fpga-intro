#include <iostream>

extern "C" {
int hello(int x) {
    std::cout << "Hello from C++: ";
    std::cout << x << std::endl;

    return x + 1;
}

}