
#include <stdint.h>

int16_t foo(int16_t a, uint8_t x, uint8_t y)
{
    uint8_t d = x - y;
    a -= (int16_t)d;
    return a;
}
int16_t foo2(int16_t a, uint8_t x, uint8_t y)
{
    int16_t d = x - y;
    a -= d;
    return a;
}
