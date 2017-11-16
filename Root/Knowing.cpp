#include <iostream>

int main(){
    unsigned short int a = 0;
    unsigned short int b = a - 1;

    signed short int c1;
    signed int c2;
    signed long long int c4;

    std::cout << sizeof(c1) << std::endl;
    std::cout << sizeof(c2) << std::endl;
    std::cout << sizeof(c4) << std::endl;
}